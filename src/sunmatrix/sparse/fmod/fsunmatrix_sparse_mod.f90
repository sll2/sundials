! This file was automatically generated by SWIG (http://www.swig.org).
! Version 4.0.0
!
! Do not make changes to this file unless you know what you are doing--modify
! the SWIG interface file instead.

! ---------------------------------------------------------------
! Programmer(s): Auto-generated by swig.
! ---------------------------------------------------------------
! SUNDIALS Copyright Start
! Copyright (c) 2002-2022, Lawrence Livermore National Security
! and Southern Methodist University.
! All rights reserved.
!
! See the top-level LICENSE and NOTICE files for details.
!
! SPDX-License-Identifier: BSD-3-Clause
! SUNDIALS Copyright End
! ---------------------------------------------------------------

module fsunmatrix_sparse_mod
 use, intrinsic :: ISO_C_BINDING
 use fsundials_matrix_mod
 use fsundials_types_mod
 use fsundials_context_mod
 use fsundials_nvector_mod
 use fsundials_context_mod
 use fsundials_types_mod
 implicit none
 private

 ! DECLARATION CONSTRUCTS
 integer(C_INT), parameter, public :: CSC_MAT = 0_C_INT
 integer(C_INT), parameter, public :: CSR_MAT = 1_C_INT
 public :: FSUNSparseMatrix
 public :: FSUNSparseFromDenseMatrix
 public :: FSUNSparseFromBandMatrix
 public :: FSUNSparseMatrix_ToCSR
 public :: FSUNSparseMatrix_ToCSC
 public :: FSUNSparseMatrix_Realloc
 public :: FSUNSparseMatrix_Reallocate
 public :: FSUNSparseMatrix_Print
 public :: FSUNSparseMatrix_Rows
 public :: FSUNSparseMatrix_Columns
 public :: FSUNSparseMatrix_NNZ
 public :: FSUNSparseMatrix_NP
 public :: FSUNSparseMatrix_SparseType
 public :: FSUNMatGetID_Sparse
 public :: FSUNMatClone_Sparse
 public :: FSUNMatDestroy_Sparse
 public :: FSUNMatZero_Sparse
 public :: FSUNMatCopy_Sparse
 public :: FSUNMatScaleAdd_Sparse
 public :: FSUNMatScaleAddI_Sparse
 public :: FSUNMatMatvec_Sparse
 public :: FSUNMatSpace_Sparse

 public :: FSUNSparseMatrix_Data
 public :: FSUNSparseMatrix_IndexValues
 public :: FSUNSparseMatrix_IndexPointers


! WRAPPER DECLARATIONS
interface
function swigc_FSUNSparseMatrix(farg1, farg2, farg3, farg4, farg5) &
bind(C, name="_wrap_FSUNSparseMatrix") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T), intent(in) :: farg1
integer(C_INT64_T), intent(in) :: farg2
integer(C_INT64_T), intent(in) :: farg3
integer(C_INT), intent(in) :: farg4
type(C_PTR), value :: farg5
type(C_PTR) :: fresult
end function

function swigc_FSUNSparseFromDenseMatrix(farg1, farg2, farg3) &
bind(C, name="_wrap_FSUNSparseFromDenseMatrix") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
real(C_DOUBLE), intent(in) :: farg2
integer(C_INT), intent(in) :: farg3
type(C_PTR) :: fresult
end function

function swigc_FSUNSparseFromBandMatrix(farg1, farg2, farg3) &
bind(C, name="_wrap_FSUNSparseFromBandMatrix") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
real(C_DOUBLE), intent(in) :: farg2
integer(C_INT), intent(in) :: farg3
type(C_PTR) :: fresult
end function

function swigc_FSUNSparseMatrix_ToCSR(farg1, farg2) &
bind(C, name="_wrap_FSUNSparseMatrix_ToCSR") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR), value :: farg2
integer(C_INT) :: fresult
end function

function swigc_FSUNSparseMatrix_ToCSC(farg1, farg2) &
bind(C, name="_wrap_FSUNSparseMatrix_ToCSC") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR), value :: farg2
integer(C_INT) :: fresult
end function

function swigc_FSUNSparseMatrix_Realloc(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_Realloc") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT) :: fresult
end function

function swigc_FSUNSparseMatrix_Reallocate(farg1, farg2) &
bind(C, name="_wrap_FSUNSparseMatrix_Reallocate") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT64_T), intent(in) :: farg2
integer(C_INT) :: fresult
end function

subroutine swigc_FSUNSparseMatrix_Print(farg1, farg2) &
bind(C, name="_wrap_FSUNSparseMatrix_Print")
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR), value :: farg2
end subroutine

function swigc_FSUNSparseMatrix_Rows(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_Rows") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT64_T) :: fresult
end function

function swigc_FSUNSparseMatrix_Columns(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_Columns") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT64_T) :: fresult
end function

function swigc_FSUNSparseMatrix_NNZ(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_NNZ") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT64_T) :: fresult
end function

function swigc_FSUNSparseMatrix_NP(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_NP") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT64_T) :: fresult
end function

function swigc_FSUNSparseMatrix_SparseType(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_SparseType") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT) :: fresult
end function

function swigc_FSUNMatGetID_Sparse(farg1) &
bind(C, name="_wrap_FSUNMatGetID_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT) :: fresult
end function

function swigc_FSUNMatClone_Sparse(farg1) &
bind(C, name="_wrap_FSUNMatClone_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR) :: fresult
end function

subroutine swigc_FSUNMatDestroy_Sparse(farg1) &
bind(C, name="_wrap_FSUNMatDestroy_Sparse")
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
end subroutine

function swigc_FSUNMatZero_Sparse(farg1) &
bind(C, name="_wrap_FSUNMatZero_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
integer(C_INT) :: fresult
end function

function swigc_FSUNMatCopy_Sparse(farg1, farg2) &
bind(C, name="_wrap_FSUNMatCopy_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR), value :: farg2
integer(C_INT) :: fresult
end function

function swigc_FSUNMatScaleAdd_Sparse(farg1, farg2, farg3) &
bind(C, name="_wrap_FSUNMatScaleAdd_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
real(C_DOUBLE), intent(in) :: farg1
type(C_PTR), value :: farg2
type(C_PTR), value :: farg3
integer(C_INT) :: fresult
end function

function swigc_FSUNMatScaleAddI_Sparse(farg1, farg2) &
bind(C, name="_wrap_FSUNMatScaleAddI_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
real(C_DOUBLE), intent(in) :: farg1
type(C_PTR), value :: farg2
integer(C_INT) :: fresult
end function

function swigc_FSUNMatMatvec_Sparse(farg1, farg2, farg3) &
bind(C, name="_wrap_FSUNMatMatvec_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR), value :: farg2
type(C_PTR), value :: farg3
integer(C_INT) :: fresult
end function

function swigc_FSUNMatSpace_Sparse(farg1, farg2, farg3) &
bind(C, name="_wrap_FSUNMatSpace_Sparse") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR), value :: farg2
type(C_PTR), value :: farg3
integer(C_INT) :: fresult
end function


function swigc_FSUNSparseMatrix_Data(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_Data") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR) :: fresult
end function

function swigc_FSUNSparseMatrix_IndexValues(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_IndexValues") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR) :: fresult
end function

function swigc_FSUNSparseMatrix_IndexPointers(farg1) &
bind(C, name="_wrap_FSUNSparseMatrix_IndexPointers") &
result(fresult)
use, intrinsic :: ISO_C_BINDING
type(C_PTR), value :: farg1
type(C_PTR) :: fresult
end function

end interface


contains
 ! MODULE SUBPROGRAMS
function FSUNSparseMatrix(m, n, nnz, sparsetype, sunctx) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
type(SUNMatrix), pointer :: swig_result
integer(C_INT64_T), intent(in) :: m
integer(C_INT64_T), intent(in) :: n
integer(C_INT64_T), intent(in) :: nnz
integer(C_INT), intent(in) :: sparsetype
type(C_PTR) :: sunctx
type(C_PTR) :: fresult 
integer(C_INT64_T) :: farg1 
integer(C_INT64_T) :: farg2 
integer(C_INT64_T) :: farg3 
integer(C_INT) :: farg4 
type(C_PTR) :: farg5 

farg1 = m
farg2 = n
farg3 = nnz
farg4 = sparsetype
farg5 = sunctx
fresult = swigc_FSUNSparseMatrix(farg1, farg2, farg3, farg4, farg5)
call c_f_pointer(fresult, swig_result)
end function

function FSUNSparseFromDenseMatrix(a, droptol, sparsetype) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
type(SUNMatrix), pointer :: swig_result
type(SUNMatrix), target, intent(inout) :: a
real(C_DOUBLE), intent(in) :: droptol
integer(C_INT), intent(in) :: sparsetype
type(C_PTR) :: fresult 
type(C_PTR) :: farg1 
real(C_DOUBLE) :: farg2 
integer(C_INT) :: farg3 

farg1 = c_loc(a)
farg2 = droptol
farg3 = sparsetype
fresult = swigc_FSUNSparseFromDenseMatrix(farg1, farg2, farg3)
call c_f_pointer(fresult, swig_result)
end function

function FSUNSparseFromBandMatrix(a, droptol, sparsetype) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
type(SUNMatrix), pointer :: swig_result
type(SUNMatrix), target, intent(inout) :: a
real(C_DOUBLE), intent(in) :: droptol
integer(C_INT), intent(in) :: sparsetype
type(C_PTR) :: fresult 
type(C_PTR) :: farg1 
real(C_DOUBLE) :: farg2 
integer(C_INT) :: farg3 

farg1 = c_loc(a)
farg2 = droptol
farg3 = sparsetype
fresult = swigc_FSUNSparseFromBandMatrix(farg1, farg2, farg3)
call c_f_pointer(fresult, swig_result)
end function

function FSUNSparseMatrix_ToCSR(a, bout) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR), target, intent(inout) :: bout
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 
type(C_PTR) :: farg2 

farg1 = c_loc(a)
farg2 = c_loc(bout)
fresult = swigc_FSUNSparseMatrix_ToCSR(farg1, farg2)
swig_result = fresult
end function

function FSUNSparseMatrix_ToCSC(a, bout) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR), target, intent(inout) :: bout
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 
type(C_PTR) :: farg2 

farg1 = c_loc(a)
farg2 = c_loc(bout)
fresult = swigc_FSUNSparseMatrix_ToCSC(farg1, farg2)
swig_result = fresult
end function

function FSUNSparseMatrix_Realloc(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_Realloc(farg1)
swig_result = fresult
end function

function FSUNSparseMatrix_Reallocate(a, nnz) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT64_T), intent(in) :: nnz
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 
integer(C_INT64_T) :: farg2 

farg1 = c_loc(a)
farg2 = nnz
fresult = swigc_FSUNSparseMatrix_Reallocate(farg1, farg2)
swig_result = fresult
end function

subroutine FSUNSparseMatrix_Print(a, outfile)
use, intrinsic :: ISO_C_BINDING
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR) :: outfile
type(C_PTR) :: farg1 
type(C_PTR) :: farg2 

farg1 = c_loc(a)
farg2 = outfile
call swigc_FSUNSparseMatrix_Print(farg1, farg2)
end subroutine

function FSUNSparseMatrix_Rows(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT64_T) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_Rows(farg1)
swig_result = fresult
end function

function FSUNSparseMatrix_Columns(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT64_T) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_Columns(farg1)
swig_result = fresult
end function

function FSUNSparseMatrix_NNZ(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT64_T) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_NNZ(farg1)
swig_result = fresult
end function

function FSUNSparseMatrix_NP(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT64_T) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_NP(farg1)
swig_result = fresult
end function

function FSUNSparseMatrix_SparseType(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_SparseType(farg1)
swig_result = fresult
end function

function FSUNMatGetID_Sparse(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(SUNMatrix_ID) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNMatGetID_Sparse(farg1)
swig_result = fresult
end function

function FSUNMatClone_Sparse(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
type(SUNMatrix), pointer :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNMatClone_Sparse(farg1)
call c_f_pointer(fresult, swig_result)
end function

subroutine FSUNMatDestroy_Sparse(a)
use, intrinsic :: ISO_C_BINDING
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR) :: farg1 

farg1 = c_loc(a)
call swigc_FSUNMatDestroy_Sparse(farg1)
end subroutine

function FSUNMatZero_Sparse(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNMatZero_Sparse(farg1)
swig_result = fresult
end function

function FSUNMatCopy_Sparse(a, b) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(SUNMatrix), target, intent(inout) :: b
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 
type(C_PTR) :: farg2 

farg1 = c_loc(a)
farg2 = c_loc(b)
fresult = swigc_FSUNMatCopy_Sparse(farg1, farg2)
swig_result = fresult
end function

function FSUNMatScaleAdd_Sparse(c, a, b) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
real(C_DOUBLE), intent(in) :: c
type(SUNMatrix), target, intent(inout) :: a
type(SUNMatrix), target, intent(inout) :: b
integer(C_INT) :: fresult 
real(C_DOUBLE) :: farg1 
type(C_PTR) :: farg2 
type(C_PTR) :: farg3 

farg1 = c
farg2 = c_loc(a)
farg3 = c_loc(b)
fresult = swigc_FSUNMatScaleAdd_Sparse(farg1, farg2, farg3)
swig_result = fresult
end function

function FSUNMatScaleAddI_Sparse(c, a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
real(C_DOUBLE), intent(in) :: c
type(SUNMatrix), target, intent(inout) :: a
integer(C_INT) :: fresult 
real(C_DOUBLE) :: farg1 
type(C_PTR) :: farg2 

farg1 = c
farg2 = c_loc(a)
fresult = swigc_FSUNMatScaleAddI_Sparse(farg1, farg2)
swig_result = fresult
end function

function FSUNMatMatvec_Sparse(a, x, y) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(N_Vector), target, intent(inout) :: x
type(N_Vector), target, intent(inout) :: y
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 
type(C_PTR) :: farg2 
type(C_PTR) :: farg3 

farg1 = c_loc(a)
farg2 = c_loc(x)
farg3 = c_loc(y)
fresult = swigc_FSUNMatMatvec_Sparse(farg1, farg2, farg3)
swig_result = fresult
end function

function FSUNMatSpace_Sparse(a, lenrw, leniw) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT) :: swig_result
type(SUNMatrix), target, intent(inout) :: a
integer(C_LONG), dimension(*), target, intent(inout) :: lenrw
integer(C_LONG), dimension(*), target, intent(inout) :: leniw
integer(C_INT) :: fresult 
type(C_PTR) :: farg1 
type(C_PTR) :: farg2 
type(C_PTR) :: farg3 

farg1 = c_loc(a)
farg2 = c_loc(lenrw(1))
farg3 = c_loc(leniw(1))
fresult = swigc_FSUNMatSpace_Sparse(farg1, farg2, farg3)
swig_result = fresult
end function



function FSUNSparseMatrix_Data(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
real(C_DOUBLE), dimension(:), pointer :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_Data(farg1)
call c_f_pointer(fresult, swig_result, [FSUNSparseMatrix_NNZ(a)])
end function

function FSUNSparseMatrix_IndexValues(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T), dimension(:), pointer :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_IndexValues(farg1)
call c_f_pointer(fresult, swig_result, [FSUNSparseMatrix_NNZ(a)])
end function

function FSUNSparseMatrix_IndexPointers(a) &
result(swig_result)
use, intrinsic :: ISO_C_BINDING
integer(C_INT64_T), dimension(:), pointer :: swig_result
type(SUNMatrix), target, intent(inout) :: a
type(C_PTR) :: fresult 
type(C_PTR) :: farg1 

farg1 = c_loc(a)
fresult = swigc_FSUNSparseMatrix_IndexPointers(farg1)
call c_f_pointer(fresult, swig_result, [FSUNSparseMatrix_NP(a)+1])
end function  


end module
