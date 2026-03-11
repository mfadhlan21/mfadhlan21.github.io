#!/bin/bash

NVCCW=$(realpath ../lib/kokkos/bin/nvcc_wrapper)
cmake \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_CXX_STANDARD=20 \
    -D CMAKE_CXX_STANDARD_REQUIRED=ON \
    -D CMAKE_CXX_COMPILER="$NVCCW" \
    -D CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -march=native -ffast-math" \
    -D BUILD_SHARED_LIBS=ON \
    -D BUILD_OMP=ON \
    -D BUILD_MPI=ON \
    -D PKG_KOKKOS=ON \
    -D PKG_EXTRA-PAIR=ON \
    -D Kokkos_ENABLE_SERIAL=ON \
    -D Kokkos_ENABLE_OPENMP=ON \
    -D Kokkos_ARCH_NATIVE=ON \
    -D Kokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON \
    -D Kokkos_ENABLE_CUDA=ON \
    -D Kokkos_ARCH_HOPPER90=ON \
    -D SYMMETRIX_KOKKOS=ON \
    -D SYMMETRIX_SPHERICART_CUDA=ON \
    ../cmake
