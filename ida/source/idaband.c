/*
 * -----------------------------------------------------------------
 * $Revision: 1.15 $
 * $Date: 2004-06-02 23:14:21 $
 * ----------------------------------------------------------------- 
 * Programmers: Alan C. Hindmarsh, and Radu Serban @ LLNL
 * -----------------------------------------------------------------
 * Copyright (c) 2002, The Regents of the University of California  
 * Produced at the Lawrence Livermore National Laboratory
 * All rights reserved
 * For details, see sundials/ida/LICENSE
 * -----------------------------------------------------------------
 * This is the implementation file for the IDA banded linear       
 * solver module, IDABAND. This module uses standard banded        
 * matrix techniques to solve the linear systems generated by the  
 * (nonlinear) Newton iteration process. The user may either       
 * supply a banded Jacobian routine or use the routine supplied    
 * with this module (IDABandDQJac).                                
 * -----------------------------------------------------------------
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ida_impl.h"
#include "idaband_impl.h"
#include "band.h"
#include "sundialstypes.h"
#include "nvector.h"
#include "sundialsmath.h"

/* Error Messages */

#define IDABAND                "IDABand-- "

#define MSG_IDAMEM_NULL        IDABAND "Integrator memory is NULL.\n\n"

#define MSG_BAD_SIZES_1        IDABAND "Illegal bandwidth parameter(s) "
#define MSG_BAD_SIZES_2        "mlower = %ld, mupper = %ld.\n"
#define MSG_BAD_SIZES_3        "Must have 0 <=  mlower, mupper <= N-1 =%ld.\n\n"
#define MSG_BAD_SIZES          MSG_BAD_SIZES_1 MSG_BAD_SIZES_2 MSG_BAD_SIZES_3

#define MSG_MEM_FAIL           IDABAND "A memory request failed.\n\n"

#define MSG_WRONG_NVEC         IDABAND "Incompatible NVECTOR implementation.\n\n"

#define MSG_SETGET_IDAMEM_NULL "IDABandSet*/IDABandGet*-- Integrator memory is NULL. \n\n"

#define MSG_SETGET_LMEM_NULL   "IDABandSet*/IDABandGet*-- IDABAND memory is NULL. \n\n"
/* Constants */

#define ZERO         RCONST(0.0)
#define ONE          RCONST(1.0)
#define TWO          RCONST(2.0)

/* IDABAND linit, lsetup, lsolve, and lfree routines */
 
static int IDABandInit(IDAMem IDA_mem);

static int IDABandSetup(IDAMem IDA_mem, N_Vector yyp, N_Vector ypp,
                        N_Vector resp, N_Vector tempv1,
                        N_Vector tempv2, N_Vector tempv3);

static int IDABandSolve(IDAMem IDA_mem, N_Vector b, N_Vector weight,
                        N_Vector ycur, N_Vector ypcur, N_Vector rescur);

static int IDABandFree(IDAMem IDA_mem);

static int IDABandDQJac(long int Neq, long int mupper, long int mlower,
                        realtype tt, N_Vector yy, N_Vector yp, realtype c_j,
                        void *jdata, N_Vector resvec, BandMat Jac,
                        N_Vector tempv1, N_Vector tempv2, N_Vector tempv3);

/* Readability Replacements */

#define res         (IDA_mem->ida_res)
#define rdata       (IDA_mem->ida_rdata)
#define uround      (IDA_mem->ida_uround)
#define tn          (IDA_mem->ida_tn)
#define hh          (IDA_mem->ida_hh)
#define cj          (IDA_mem->ida_cj)
#define cjratio     (IDA_mem->ida_cjratio)
#define ewt         (IDA_mem->ida_ewt)
#define constraints (IDA_mem->ida_constraints)
#define nre         (IDA_mem->ida_nre)
#define errfp       (IDA_mem->ida_errfp)
#define iopt        (IDA_mem->ida_iopt)
#define linit       (IDA_mem->ida_linit)
#define lsetup      (IDA_mem->ida_lsetup)
#define lsolve      (IDA_mem->ida_lsolve)
#define lperf       (IDA_mem->ida_lperf)
#define lfree       (IDA_mem->ida_lfree)
#define lmem        (IDA_mem->ida_lmem)
#define setupNonNull (IDA_mem->ida_setupNonNull)
#define nvspec      (IDA_mem->ida_nvspec)

#define neq         (idaband_mem->b_neq)
#define ml          (idaband_mem->b_mlower)
#define mu          (idaband_mem->b_mupper)
#define jac         (idaband_mem->b_jac)
#define JJ          (idaband_mem->b_J)
#define storage_mu  (idaband_mem->b_storage_mu)
#define pivots      (idaband_mem->b_pivots)
#define nje         (idaband_mem->b_nje)
#define nreB        (idaband_mem->b_nreB)
#define jacdata     (idaband_mem->b_jdata)
 
                  
/*************** IDABand *********************************************

 This routine initializes the memory record and sets various function
 fields specific to the IDABAND linear solver module.
 IDABand first calls the existing lfree routine if this is not NULL.
 Then it sets the ida_linit, ida_lsetup, ida_lsolve, ida_lperf, and
 ida_lfree fields in (*IDA_mem) to be IDABandInit, IDABandSetup,
 IDABandSolve, NULL, and IDABandFree, respectively.
 It allocates memory for a structure of type IDABandMemRec and sets
 the ida_lmem field in (*IDA_mem) to the address of this structure.
 It sets setupNonNull in (*IDA_mem) to TRUE, sets the b_jdata field in
 the IDABandMemRec structure to be the input parameter jdata, and sets
 the b_jac field to be:
   (1) the input parameter bjac, if bjac != NULL, or
   (2) IDABandDQJac, if bjac == NULL.
 Finally, it allocates memory for JJ and pivots.
 IDABand returns SUCCESS = 0, LMEM_FAIL = -1, or LIN_ILL_INPUT = -2.

 NOTE: The band linear solver assumes a serial implementation
       of the NVECTOR package. Therefore, IDABand will first 
       test for compatible a compatible N_Vector internal
       representation by checking (1) the machine environment
       ID tag and (2) that the functions N_VMake, N_VDispose,
       N_VGetData, and N_VSetData are implemented.

**********************************************************************/

int IDABand(void *ida_mem, long int Neq, 
            long int mupper, long int mlower)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;
  int flag;

  /* Return immediately if ida_mem is NULL. */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_MEM_FAIL);
    return(LMEM_FAIL);
  }
  IDA_mem = (IDAMem) ida_mem;

  /* Test if the NVECTOR package is compatible with the BAND solver */
  if ((strcmp(nvspec->tag,"serial")) || 
      nvspec->ops->nvmake    == NULL || 
      nvspec->ops->nvdispose == NULL ||
      nvspec->ops->nvgetdata == NULL || 
      nvspec->ops->nvsetdata == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_WRONG_NVEC);
    return(LIN_ILL_INPUT);
  }

  if (lfree != NULL) flag = lfree(ida_mem);

  /* Set five main function fields in ida_mem. */
  linit  = IDABandInit;
  lsetup = IDABandSetup;
  lsolve = IDABandSolve;
  lperf  = NULL;
  lfree  = IDABandFree;

  /* Get memory for IDABandMemRec. */
  idaband_mem = (IDABandMem) malloc(sizeof(IDABandMemRec));
  if (idaband_mem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_MEM_FAIL);
    return(LMEM_FAIL);
  }

  /* Set default Jacobian routine and Jacobian data */
  jac = IDABandDQJac;
  jacdata = IDA_mem;

  setupNonNull = TRUE;

  /* Store problem size */
  neq = Neq;

  /* Test mlower and mupper for legality and load in memory. */
  if ((mlower < 0) || (mupper < 0) || (mlower >= Neq) || (mupper >= Neq)) {
    if(errfp!=NULL) fprintf(errfp, MSG_BAD_SIZES, mlower, mupper, Neq-1);
    return(LIN_ILL_INPUT);
  }
  idaband_mem->b_mlower = mlower;
  idaband_mem->b_mupper = mupper;
    
  /* Set extended upper half-bandwidth for JJ (required for pivoting). */
  storage_mu = MIN(Neq-1, mupper + mlower);

  /* Allocate memory for JJ and pivot array. */
  JJ = BandAllocMat(Neq, mupper, mlower, storage_mu);
  if (JJ == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_MEM_FAIL);
    return(LMEM_FAIL);
  }
  pivots = BandAllocPiv(Neq);
  if (pivots == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_MEM_FAIL);
    BandFreeMat(JJ);
    return(LMEM_FAIL);
  }  
  
  /* Attach linear solver memory to the integrator memory */
  lmem = idaband_mem;

  return(SUCCESS);
}

/************* IDABandSetJacFn ***************************************/

int IDABandSetJacFn(void *ida_mem, IDABandJacFn bjac)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* Return immediately if ida_mem is NULL */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_SETGET_IDAMEM_NULL);
    return(LIN_NO_MEM);
  }
  IDA_mem = (IDAMem) ida_mem;

  if (lmem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_SETGET_LMEM_NULL);
    return(LIN_NO_LMEM);
  }
  idaband_mem = (IDABandMem) lmem;

  jac = bjac;

  return(SUCCESS);
}

/************* IDABandSetJacData **************************************/

int IDABandSetJacData(void *ida_mem, void *jdata)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* Return immediately if ida_mem is NULL */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_SETGET_IDAMEM_NULL);
    return(LIN_NO_MEM);
  }
  IDA_mem = (IDAMem) ida_mem;

  if (lmem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_SETGET_LMEM_NULL);
    return(LIN_NO_LMEM);
  }
  idaband_mem = (IDABandMem) lmem;

  jacdata = jdata;

  return(SUCCESS);
}

/************* IDABandGetIntWorkSpace *********************************/

int IDABandGetIntWorkSpace(void *ida_mem, long int *leniwB)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* Return immediately if ida_mem is NULL */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_SETGET_IDAMEM_NULL);
    return(LIN_NO_MEM);
  }
  IDA_mem = (IDAMem) ida_mem;

  if (lmem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_SETGET_LMEM_NULL);
    return(LIN_NO_LMEM);
  }
  idaband_mem = (IDABandMem) lmem;

  *leniwB = neq;

  return(OKAY);
}

/************* IDABandGetRealWorkSpace ********************************/

int IDABandGetRealWorkSpace(void *ida_mem, long int *lenrwB)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* Return immediately if ida_mem is NULL */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_SETGET_IDAMEM_NULL);
    return(LIN_NO_MEM);
  }
  IDA_mem = (IDAMem) ida_mem;

  if (lmem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_SETGET_LMEM_NULL);
    return(LIN_NO_LMEM);
  }
  idaband_mem = (IDABandMem) lmem;

  *lenrwB = neq*(storage_mu + ml + 1);

  return(OKAY);
}

/************* IDABandGetNumJacEvals **********************************/

int IDABandGetNumJacEvals(void *ida_mem, long int *njevalsB)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* Return immediately if ida_mem is NULL */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_SETGET_IDAMEM_NULL);
    return(LIN_NO_MEM);
  }
  IDA_mem = (IDAMem) ida_mem;

  if (lmem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_SETGET_LMEM_NULL);
    return(LIN_NO_LMEM);
  }
  idaband_mem = (IDABandMem) lmem;

  *njevalsB = nje;

  return(OKAY);
}

/************* IDABandGetNumResEvals **********************************/

int IDABandGetNumResEvals(void *ida_mem, long int *nrevalsB)
{
  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* Return immediately if ida_mem is NULL */
  if (ida_mem == NULL) {
    fprintf(stderr, MSG_SETGET_IDAMEM_NULL);
    return(LIN_NO_MEM);
  }
  IDA_mem = (IDAMem) ida_mem;

  if (lmem == NULL) {
    if(errfp!=NULL) fprintf(errfp, MSG_SETGET_LMEM_NULL);
    return(LIN_NO_LMEM);
  }
  idaband_mem = (IDABandMem) lmem;

  *nrevalsB = nreB;

  return(OKAY);
}

/*************** IDABandInit *****************************************

 This routine does remaining initializations specific to the IDABAND
 linear solver module.  It returns LINIT_OK = 0.

***********************************************************************/

static int IDABandInit(IDAMem IDA_mem)
{
  IDABandMem idaband_mem;

  idaband_mem = (IDABandMem) lmem;

  /* Initialize nje and nreB */
  nje  = 0;
  nreB = 0;

  if (jac == NULL) {
    jac = IDABandDQJac;
    jacdata = IDA_mem;
  }

  return(LINIT_OK);
}


/*************** IDABandSetup ****************************************

 This routine does the setup operations for the IDABAND linear 
 solver module.  It calls the Jacobian evaluation routine,
 updates counters, and calls the band LU factorization routine.
 The return value is either
     SUCCESS = 0        if successful,
     LSETUP_ERROR_RECVR if the jac routine failed recoverably or the
                        LU factorization failed, or
     LSETUP_ERROR_NONRECVR if the jac routine failed unrecoverably.
**********************************************************************/

static int IDABandSetup(IDAMem IDA_mem, N_Vector yyp, N_Vector ypp,
                        N_Vector resp, N_Vector tempv1, N_Vector tempv2,
                        N_Vector tempv3)
{
  int retval;
  long int retfac;
  IDABandMem idaband_mem;
  
  idaband_mem = (IDABandMem) lmem;

  /* Increment nje counter. */
  nje++;

  /* Zero out JJ; call Jacobian routine jac; return if it failed. */
  BandZero(JJ);
  retval = jac(neq, mu, ml, tn, yyp, ypp, cj,
               jacdata, resp, JJ, tempv1, tempv2, tempv3);
  if (retval < 0) return(LSETUP_ERROR_NONRECVR);
  if (retval > 0) return(LSETUP_ERROR_RECVR);

  /* Do LU factorization of JJ; return success or fail flag. */
  retfac = BandFactor(JJ, pivots);

  if (retfac != SUCCESS) return(LSETUP_ERROR_RECVR);
  return(SUCCESS);
}



/*************** IDABandSolve ****************************************

 This routine handles the solve operation for the IDABAND linear
 solver module.  It calls the band backsolve routine, scales the
 solution vector according to cjratio, then returns SUCCESS = 0.

**********************************************************************/

static int IDABandSolve(IDAMem IDA_mem, N_Vector b, N_Vector weight,
                        N_Vector ycur, N_Vector ypcur, N_Vector rescur)
{
  IDABandMem idaband_mem;
  realtype *bd;

  idaband_mem = (IDABandMem) lmem;
  
  bd = N_VGetData(b);
  BandBacksolve(JJ, pivots, bd);
  N_VSetData(bd, b);

  /* Scale the correction to account for change in cj. */
  if (cjratio != ONE) N_VScale(TWO/(ONE + cjratio), b, b);

  return(SUCCESS);
}



/*************** IDABandFree *****************************************

 This routine frees memory specific to the IDABAND linear solver.

**********************************************************************/

static int IDABandFree(IDAMem IDA_mem)
{
  IDABandMem idaband_mem;

  idaband_mem = (IDABandMem) lmem;
  
  BandFreeMat(JJ);
  BandFreePiv(pivots);
  free(lmem);

  return(0);

}

/*************** IDABandDQJac ****************************************

 This routine generates a banded difference quotient approximation JJ
 to the DAE system Jacobian J.  It assumes that a band matrix of type
 BandMat is stored column-wise, and that elements within each column
 are contiguous.  The address of the jth column of JJ is obtained via
 the macros BAND_COL and BAND_COL_ELEM. The columns of the Jacobian are 
 constructed using mupper + mlower + 1 calls to the res routine, and
 appropriate differencing.
 The return value is either SUCCESS = 0, or the nonzero value returned
 by the res routine, if any.
**********************************************************************/

static int IDABandDQJac(long int Neq, long int mupper, long int mlower,
                        realtype tt, N_Vector yy, N_Vector yp, realtype c_j,
                        void *jdata, N_Vector resvec, BandMat Jac,
                        N_Vector tempv1, N_Vector tempv2, N_Vector tempv3)
{
  realtype inc, inc_inv, yj, ypj, srur, conj, ewtj;
  realtype *y_data, *yp_data, *ewt_data, *cns_data = NULL;
  realtype *ytemp_data, *yptemp_data, *rtemp_data, *r_data, *col_j;
  int group, ngroups;
  
  N_Vector rtemp, ytemp, yptemp;
  long int i, j, i1, i2, width;
  int retval = SUCCESS;

  IDAMem IDA_mem;
  IDABandMem idaband_mem;

  /* jdata points to IDA_mem */
  IDA_mem = (IDAMem) jdata;
  idaband_mem = lmem;

  rtemp = tempv1; /* Rename work vector for use as the perturbed residual. */

  ytemp = tempv2; /* Rename work vector for use as a temporary for yy. */


  yptemp= tempv3; /* Rename work vector for use as a temporary for yp. */

  /* Obtain pointers to the data for all eight vectors used.  */

  ewt_data = N_VGetData(ewt);
  r_data   = N_VGetData(resvec);
  y_data   = N_VGetData(yy);
  yp_data  = N_VGetData(yp);

  rtemp_data   = N_VGetData(rtemp);
  ytemp_data   = N_VGetData(ytemp);
  yptemp_data  = N_VGetData(yptemp);

  if (constraints != NULL) cns_data = N_VGetData(constraints);

  /* Initialize ytemp and yptemp. */

  N_VScale(ONE, yy, ytemp);
  N_VScale(ONE, yp, yptemp);

  /* Compute miscellaneous values for the Jacobian computation. */

  srur = RSqrt(uround);
  width = mlower + mupper + 1;
  ngroups = MIN(width, neq);

  /* Loop over column groups. */
  for (group=1; group <= ngroups; group++) {

    /* Increment all yy[j] and yp[j] for j in this group. */

    for (j=group-1; j<Neq; j+=width) {
        yj = y_data[j];
        ypj = yp_data[j];
        ewtj = ewt_data[j];

        /* Set increment inc to yj based on sqrt(uround)*abs(yj), with
        adjustments using ypj and ewtj if this is small, and a further
        adjustment to give it the same sign as hh*ypj. */

        inc = srur*MAX(ABS(yj), MAX( ABS(hh*ypj), ONE/ewtj));
        if (hh*ypj < ZERO) inc = -inc;
        inc = (yj + inc) - yj;

        /* Adjust sign(inc) again if yj has an inequality constraint. */
        if (constraints != NULL) {
          conj = cns_data[j];
          if (ABS(conj) == ONE)      {if((yj+inc)*conj <  ZERO) inc = -inc;}
          else if (ABS(conj) == TWO) {if((yj+inc)*conj <= ZERO) inc = -inc;}
        }

        /* Increment yj and ypj. */

        ytemp_data[j] += inc;
        yptemp_data[j] += cj*inc;
    }

    /* Call res routine with incremented arguments. */
    N_VSetData(ytemp_data, ytemp);
    N_VSetData(yptemp_data, yptemp);

    retval = res(tt, ytemp, yptemp, rtemp, rdata);
    nreB++;
    if (retval != SUCCESS) break;

    rtemp_data = N_VGetData(rtemp);

    /* Loop over the indices j in this group again. */

    for (j=group-1; j<Neq; j+=width) {

      /* Reset ytemp and yptemp components that were perturbed. */

      yj = ytemp_data[j]  = y_data[j];
      ypj = yptemp_data[j] = yp_data[j];
      col_j = BAND_COL(Jac, j);
      ewtj = ewt_data[j];
      
      
      /* Set increment inc exactly as above. */
      
      inc = srur*MAX(ABS(yj),MAX( ABS(hh*ypj), ONE/ewtj));
      if (hh*ypj < ZERO) inc = -inc;
      inc = (yj + inc) - yj;
      if (constraints != NULL) {
        conj = cns_data[j];
        if (ABS(conj) == ONE)      {if((yj+inc)*conj <  ZERO) inc = -inc;}
        else if (ABS(conj) == TWO) {if((yj+inc)*conj <= ZERO) inc = -inc;}
      }
      
      /* Load the difference quotient Jacobian elements for column j. */

      inc_inv = ONE/inc;
      i1 = MAX(0, j-mupper);
      i2 = MIN(j+mlower,neq-1);
      
      for (i=i1; i<=i2; i++) 
            BAND_COL_ELEM(col_j,i,j) = inc_inv*(rtemp_data[i]-r_data[i]);
    }
    
  }
  
  return(retval);
  
}

