#!/bin/bash
# ------------------------------------------------------------------------------
# Programmer(s): Cody J. Balos and David J. Gardner @ LLNL
# ------------------------------------------------------------------------------
# SUNDIALS Copyright Start
# Copyright (c) 2002-2022, Lawrence Livermore National Security
# and Southern Methodist University.
# All rights reserved.
#
# See the top-level LICENSE and NOTICE files for details.
#
# SPDX-License-Identifier: BSD-3-Clause
# SUNDIALS Copyright End
# ------------------------------------------------------------------------------
# Script that sets up the default SUNDIALS testing environment.
#
# Usage: source default.sh <compiler spec> <build type>
#
# Optional Inputs:
#   <compiler spec> = Compiler to build sundials with:
#                       gcc@4.9.4
#   <build type>    = SUNDIALS build type:
#                       dbg : debug build
#                       opt : optimized build
# ------------------------------------------------------------------------------

echo "./default.sh $*" | tee -a configure.log

# set defaults for optional inputs
compiler="gcc@4.9.4" # compiler spec
bldtype="dbg"        # build type dbg = debug or opt = optimized

# set optional inputs if provided
if [ "$#" -gt 0 ]; then
    compiler=$1
fi

if [ "$#" -gt 1 ]; then
    bldtype=$2
fi

# get compiler name and version from spec
compilername="${compiler%%@*}"
compilerversion="${compiler##*@}"

# ------------------------------------------------------------------------------
# Check input values
# ------------------------------------------------------------------------------

case "$SUNDIALS_PRECISION" in
    single|double|extended) ;;
    *)
        echo "ERROR: Unknown real type option: $SUNDIALS_PRECISION"
        return 1
        ;;
esac

case "$SUNDIALS_INDEX_SIZE" in
    32|64) ;;
    *)
        echo "ERROR: Unknown index size option: $SUNDIALS_INDEX_SIZE"
        return 1
        ;;
esac

case "$compiler" in
    gcc@4.9.4);;
    *)
        echo "ERROR: Unknown compiler spec: $compiler"
        return 1
        ;;
esac

case "$bldtype" in
    dbg|opt) ;;
    *)
        echo "ERROR: Unknown build type: $bldtype"
        return 1
        ;;
esac

# ------------------------------------------------------------------------------
# Setup environment
# ------------------------------------------------------------------------------

# set file permissions (rwxrwxr-x)
umask 002

# path to shared installs
APPROOT=/usr/casc/sundials/share

# setup the python environment
source ${APPROOT}/python-venv/sundocs/bin/activate

# setup spack
export SPACK_ROOT=${APPROOT}/sundials-tpls-v0.17.0/spack

# shellcheck disable=SC1090
source ${SPACK_ROOT}/share/spack/setup-env.sh

# load compiler
spack load "${compiler}"

# make sure spack knows about the compiler
spack compiler find

# load CMake
spack load "cmake@3.12.4%${compiler}"

# add CUDA
if [[ ":${PATH}:" != *":/usr/local/cuda-11.5/bin:"* ]]; then
    export PATH="/usr/local/cuda-11.5/bin${PATH:+:${PATH}}"
fi

if [[ ":${LD_LIBRARY_PATH}:" != *":/usr/local/cuda-11.5/lib64:"* ]]; then
    export LD_LIBRARY_PATH="/usr/local/cuda-11.5/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
fi

# ------------------------------------------------------------------------------
# Compilers and flags
# ------------------------------------------------------------------------------

if [ "$compilername" == "gcc" ]; then

    COMPILER_ROOT="$(spack location -i "$compiler")"
    export CC="${COMPILER_ROOT}/bin/gcc"
    export CXX="${COMPILER_ROOT}/bin/g++"
    export FC="${COMPILER_ROOT}/bin/gfortran"

    # optimization flags
    if [ "$bldtype" == "dbg" ]; then
        export CFLAGS="-g -O0"
        export CXXFLAGS="-g -O0"
        export FFLAGS="-g -O0"
        export CUDAFLAGS="-g -O0"
    else
        export CFLAGS="-g -O3"
        export CXXFLAGS="-g -O3"
        export FFLAGS="-g -O3"
        export CUDAFLAGS="-g -O3"
    fi

    # append additional warning flags
    if [[ "$SUNDIALS_PRECISION" == "double" && "$SUNDIALS_INDEX_SIZE" == "32" ]]; then
        export CFLAGS="${CFLAGS} -Wconversion -Wno-sign-conversion"
        export CXXFLAGS="${CXXFLAGS} -Wconversion -Wno-sign-conversion"
    fi

else

    COMPILER_ROOT="$(spack location -i "llvm@$compilerversion")"
    export CC="${COMPILER_ROOT}/bin/clang"
    export CXX="${COMPILER_ROOT}/bin/clang++"

    # optimization flags
    if [ "$bldtype" == "dbg" ]; then
        export CFLAGS="-g -O0"
        export CXXFLAGS="-g -O0"
        export CUDAFLAGS="-g -O0"
    else
        export CFLAGS="-g -O3"
        export CXXFLAGS="-g -O3"
        export CUDAFLAGS="-g -O3"
    fi

fi

# ------------------------------------------------------------------------------
# SUNDIALS Options
# ------------------------------------------------------------------------------

# Verbose build
export CMAKE_VERBOSE_MAKEFILE=OFF

# Number of build and test jobs
export SUNDIALS_BUILD_JOBS=4
export SUNDIALS_TEST_JOBS=1

# Sundials packages
export SUNDIALS_ARKODE=ON
export SUNDIALS_CVODE=ON
export SUNDIALS_CVODES=ON
export SUNDIALS_IDA=ON
export SUNDIALS_IDAS=ON
export SUNDIALS_KINSOL=ON

# Fortran interface status
if [ "$compilername" == "gcc" ]; then
    if [[ ("$SUNDIALS_PRECISION" == "double") && ("$SUNDIALS_INDEX_SIZE" == "64") ]]; then
        export SUNDIALS_FMOD_INTERFACE=ON
    else
        export SUNDIALS_FMOD_INTERFACE=OFF
    fi
else
    export SUNDIALS_FMOD_INTERFACE=OFF
fi

# Sundials benchmarks
export SUNDIALS_BENCHMARKS=ON

# Sundials monitoring
export SUNDIALS_MONITORING=ON

# Sundials profiling
export SUNDIALS_PROFILING=ON

# Sundials logging
export SUNDIALS_LOGGING_LEVEL=4
export SUNDIALS_LOGGING_ENABLE_MPI=ON

# Uncomment to override the default output file comparison precisions. The float
# precision is number of digits to compare (0 = all digits) and the integer
# precision is allowed percentage difference (0 = no difference).
export SUNDIALS_TEST_FLOAT_PRECISION=0
export SUNDIALS_TEST_INTEGER_PRECISION=0

# ------------------------------------------------------------------------------
# Third party libraries
# ------------------------------------------------------------------------------

# -------
# PThread
# -------

export SUNDIALS_PTHREAD=ON

# ------
# OpenMP
# ------

export SUNDIALS_OPENMP=ON
export OMP_NUM_THREADS=4

# ---------------------
# OpenMP Device Offload
# ---------------------

export SUNDIALS_OPENMP_OFFLOAD=OFF

# ----
# CUDA
# ----

if [ "$SUNDIALS_PRECISION" != "extended" ]; then
    export SUNDIALS_CUDA=ON
    export CUDAARCHS=60
    export SUNDIALS_FUSED_KERNELS=ON
else
    export SUNDIALS_CUDA=OFF
    export SUNDIALS_FUSED_KERNELS=OFF
fi

# ---
# MPI
# ---

MPI_ROOT="$(spack location -i openmpi@4.1.1 % "$compiler")"

export SUNDIALS_MPI=ON
export MPICC="${MPI_ROOT}/bin/mpicc"
export MPICXX="${MPI_ROOT}/bin/mpicxx"
export MPIFC="${MPI_ROOT}/bin/mpifort"
export MPIEXEC="${MPI_ROOT}/bin/mpirun"

# -------------
# LAPACK / BLAS
# -------------

if [ "$SUNDIALS_PRECISION" != "extended" ]; then
    export SUNDIALS_LAPACK=ON
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        LAPACK_ROOT="$(spack location -i openblas@0.3.18~ilp64 % "$compiler")"
    else
        LAPACK_ROOT="$(spack location -i openblas@0.3.18+ilp64 % "$compiler")"
    fi
    export LAPACK_LIBRARIES="${LAPACK_ROOT}/lib/libopenblas.so"
else
    export SUNDIALS_LAPACK=OFF
    unset LAPACK_LIBRARIES
fi

# ---
# KLU
# ---

if [ "$SUNDIALS_PRECISION" == "double" ]; then
    export SUNDIALS_KLU=ON
    SUITE_SPARSE_ROOT="$(spack location -i suite-sparse@5.10.1 % "$compiler")"
    export SUITE_SPARSE_INCLUDE_DIR="${SUITE_SPARSE_ROOT}/include"
    export SUITE_SPARSE_LIBRARY_DIR="${SUITE_SPARSE_ROOT}/lib"
else
    export SUNDIALS_KLU=OFF
    unset SUITE_SPARSE_ROOT
fi

# -----
# MAGMA
# -----

if [ "$SUNDIALS_PRECISION" != "extended" ] && \
    [ "$SUNDIALS_INDEX_SIZE" == "32" ] && \
    [ "$SUNDIALS_CUDA" == "ON" ]; then
    export SUNDIALS_MAGMA=ON
    export MAGMA_ROOT="$(spack location -i magma@2.6.1 % "$compiler")"
    export MAGMA_BACKENDS="CUDA"
else
    export SUNDIALS_MAGMA=OFF
    unset MAGMA_ROOT
    unset MAGMA_BACKENDS
fi

# ----------
# SuperLU_MT
# ----------

if [ "$SUNDIALS_PRECISION" != "extended" ]; then
    export SUNDIALS_SUPERLU_MT=ON
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        SUPERLU_MT_ROOT="$(spack location -i superlu-mt@3.1~int64~blas % "$compiler")"
    else
        SUPERLU_MT_ROOT="$(spack location -i superlu-mt@3.1+int64~blas % "$compiler")"
    fi
    export SUPERLU_MT_INCLUDE_DIR="${SUPERLU_MT_ROOT}/include"
    export SUPERLU_MT_LIBRARY_DIR="${SUPERLU_MT_ROOT}/lib"
    export SUPERLU_MT_LIBRARIES="${SUPERLU_MT_ROOT}/lib/libblas_PTHREAD.a"
    export SUPERLU_MT_THREAD_TYPE="PTHREAD"
else
    export SUNDIALS_SUPERLU_MT=OFF
    unset SUPERLU_MT_ROOT
    unset SUPERLU_MT_INCLUDE_DIR
    unset SUPERLU_MT_LIBRARY_DIR
    unset SUPERLU_MT_LIBRARIES
    unset SUPERLU_MT_THREAD_TYPE
fi

# ------------
# SuperLU_DIST
# ------------

if [ "$SUNDIALS_PRECISION" == "double" ]; then
    export SUNDIALS_SUPERLU_DIST=ON
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        SUPERLU_DIST_ROOT="$(spack location -i superlu-dist@7.1.1~int64+openmp % "$compiler")"
    else
        SUPERLU_DIST_ROOT="$(spack location -i superlu-dist@7.1.1+int64+openmp % "$compiler")"
    fi
    export SUPERLU_DIST_INCLUDE_DIR="${SUPERLU_DIST_ROOT}/include"
    export SUPERLU_DIST_LIBRARY_DIR="${SUPERLU_DIST_ROOT}/lib"

    # built with 32-bit blas
    BLAS_ROOT="$(spack location -i openblas@0.3.18~ilp64 % "$compiler")"
    BLAS_LIBRARIES=${BLAS_ROOT}/lib/libopenblas.so

    # PARMETIS
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        PARMETIS_ROOT="$(spack location -i parmetis ^metis~int64~real64 % "$compiler")"
    else
        PARMETIS_ROOT="$(spack location -i parmetis ^metis+int64~real64 % "$compiler")"
    fi
    PARMETIS_LIBRARIES="${PARMETIS_ROOT}/lib/libparmetis.so"

    # METIS
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        METIS_ROOT="$(spack location -i metis~int64~real64 % "$compiler")"
    else
        METIS_ROOT="$(spack location -i metis+int64~real64 % "$compiler")"
    fi
    METIS_LIBRARIES="${METIS_ROOT}/lib/libmetis.so"

    export SUPERLU_DIST_LIBRARIES="${BLAS_LIBRARIES};${PARMETIS_LIBRARIES};${METIS_LIBRARIES};${SUPERLU_DIST_ROOT}/lib/libsuperlu_dist.a"
    export SUPERLU_DIST_OPENMP=OFF
else
    export SUNDIALS_SUPERLU_DIST=OFF
    unset SUPERLU_DIST_INCLUDE_DIR
    unset SUPERLU_DIST_LIBRARY_DIR
    unset SUPERLU_DIST_LIBRARIES
    unset SUPERLU_DIST_OPENMP
fi

# -----
# hypre
# -----

if [ "$SUNDIALS_PRECISION" == "double" ]; then
    export SUNDIALS_HYPRE=ON
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        HYPRE_ROOT="$(spack location -i hypre@2.23.0~int64 % "$compiler")"
    else
        HYPRE_ROOT="$(spack location -i hypre@2.23.0+int64 % "$compiler")"
    fi
    export HYPRE_INCLUDE_DIR="${HYPRE_ROOT}/include"
    export HYPRE_LIBRARY_DIR="${HYPRE_ROOT}/lib"
else
    export SUNDIALS_HYPRE=OFF
    unset HYPRE_INCLUDE_DIR
    unset HYPRE_LIBRARY_DIR
fi

# -----
# petsc
# -----

if [ "$SUNDIALS_PRECISION" == "double" ]; then
    export SUNDIALS_PETSC=ON
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        PETSC_ROOT="$(spack location -i petsc@3.16.1~int64 % "$compiler")"
    else
        PETSC_ROOT="$(spack location -i petsc@3.16.1+int64 % "$compiler")"
    fi
    export PETSC_ROOT
else
    export SUNDIALS_PETSC=OFF
    unset PETSC_ROOT
fi

# --------
# trilinos
# --------

if [ "$SUNDIALS_PRECISION" == "double" ] && [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
    export SUNDIALS_TRILINOS=ON
    if [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
        TRILINOS_ROOT="$(spack location -i trilinos@13.0.1 gotype=int % "$compiler")"
    else
        TRILINOS_ROOT="$(spack location -i trilinos@13.0.1 gotype=long_long % "$compiler")"
    fi
    export TRILINOS_ROOT
else
    export SUNDIALS_TRILINOS=OFF
    unset TRILINOS_ROOT
fi

# ----
# raja
# ----

if [ "$SUNDIALS_PRECISION" == "double" ]; then
    export SUNDIALS_RAJA=ON
    export RAJA_ROOT="$(spack location -i raja@0.14.0 % "$compiler")"
    export RAJA_BACKENDS="CUDA"
else
    export SUNDIALS_RAJA=OFF
    unset RAJA_ROOT
    unset RAJA_BACKENDS
fi

# ------
# xbraid
# ------

if [ "$SUNDIALS_PRECISION" == "double" ] && [ "$SUNDIALS_INDEX_SIZE" == "32" ]; then
    export SUNDIALS_XBRAID=ON
    export XBRAID_ROOT="$(spack location -i xbraid@3.0.0 % "$compiler")"
else
    export SUNDIALS_XBRAID=OFF
    unset XBRAID_ROOT
fi