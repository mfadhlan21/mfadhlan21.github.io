#!/bin/sh
#PBS -q F1accs
#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=64:mpiprocs=4:ompthreads=1
#PBS -l place=scatter
#PBS -N md_10_HxHCOO_high

source ~/.bash_profile
conda activate mace2

module load cuda/12.4 compiler-rt gcc/12.2.0 openmpi_gcc_8.5.0_cuda_12.4/4.1.8 tbb/2021.12
module load mkl/2024.1

export OMP_NUM_THREADS=1
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# CUDA-aware MPI: UCX must not use the cma transport for device pointers
# (process_vm_readv -> "Bad address").  See 10_H+HCOO_high/BENCHMARK_RESULTS.md.
export UCX_MEMTYPE_CACHE=n
export UCX_TLS=self,sm,cuda_copy,cuda_ipc

cd $PBS_O_WORKDIR

LAMMPS_CMD=/home/k0107/k010732/lammps-symmetrix/build/lmp

echo "===== allocation ====="
echo "PBS_JOBID = $PBS_JOBID"
cat $PBS_NODEFILE
nvidia-smi -L
echo "======================"

mpiexec -n 4 -x CUDA_VISIBLE_DEVICES -x UCX_TLS -x UCX_MEMTYPE_CACHE \
        -x OMP_NUM_THREADS -x OMP_PROC_BIND -x OMP_PLACES \
        $LAMMPS_CMD -k on g 4 -sf kk \
        -pk kokkos newton on neigh half \
        -in lammps.in

# lmp exits 134 (SIGABRT in a Kokkos static destructor) after all output is
# written; that is harmless, so report the run as finished either way.
echo "lmp exit status = $?"
