module load gcc/11.4.0

pip install cython==0.29.36
export CC=$(which gcc)
cmake     -D CMAKE_BUILD_TYPE=Release     -D CMAKE_INSTALL_PREFIX=$(pwd)     -D BUILD_MPI=ON     -D BUILD_SHARED_LIBS=ON     -D PKG_KOKKOS=ON     -D Kokkos_ENABLE_CUDA=ON     -D CMAKE_CXX_COMPILER=$(pwd)/../lib/kokkos/bin/nvcc_wrapper     -D Kokkos_ARCH_NATIVE=ON     -D Kokkos_ARCH_AMPERE80=ON      -D PKG_ML-IAP=ON -D PKG_ML-SNAP=ON -D MLIAP_ENABLE_PYTHON=ON -D PKG_PYTHON=ON -DPKG_EXTRA-PAIR=ON   ../cmake

symmetrix
module load BaseGCC/2025
module load gcc/11.4.0 cuda/12.6
module load cudnn/9.8.0.87 
NVCCW=$(realpath ../lib/kokkos/bin/nvcc_wrapper)
cmake -D CMAKE_BUILD_TYPE=Release   -D CMAKE_CXX_STANDARD=20 -D CMAKE_CXX_STANDARD_REQUIRED=ON   -D CMAKE_CXX_COMPILER="$NVCCW"   -D CMAKE_C_COMPILER=$(which gcc)   -D CMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS} -march=native -ffast-math"   -D BUILD_SHARED_LIBS=ON -D BUILD_OMP=ON -D BUILD_MPI=ON   -D PKG_KOKKOS=ON -D PKG_EXTRA-PAIR=ON   -D Kokkos_ENABLE_SERIAL=ON -D Kokkos_ENABLE_OPENMP=ON   -D Kokkos_ENABLE_CUDA=ON -D Kokkos_ARCH_AMPERE80=ON   -D Kokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON   -D SYMMETRIX_KOKKOS=ON -D SYMMETRIX_SPHERICART_CUDA=ON   ../cmake
