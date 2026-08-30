#!/bin/sh
#PBS -q DBG
#PBS --group=K2613
#PBS -l elapstim_req=00:10:00
#PBS -b 1
#PBS -l gpunum_job=8
#PBS -N md.8gpu
#PBS -T openmpi
#PBS -v NQSV_MPI_MODULE=BaseGPU/2025:BaseGCC/2025:gcc/11.4.0:cudnn/9.8.0.87

source ~/.bash_profile
#conda deactivate
conda activate mace

module load BaseGPU/2025
module load BaseGCC/2025
module load gcc/11.4.0
module load cudnn/9.8.0.87

export LD_LIBRARY_PATH=$(echo "$LD_LIBRARY_PATH" | tr ':' '\n' | grep -v '/lib64/stubs' | paste -sd: -)

# Force CUDA primary context creation
python - <<'PY'
import ctypes
ctypes.CDLL("libcudart.so.12").cudaFree(0)
print("CUDA context initialized")
PY

cd $PBS_O_WORKDIR

#LAMMPS_CMD=/sqfs/home/z6b781/work/lammps-mliap/build/lmp
LAMMPS_CMD=/sqfs/home/u6d174/work/lammps-symmetrix/build/lmp
mpirun ${NQSV_MPIOPTS} -np 8 $LAMMPS_CMD -k on g 8 -sf kk -pk kokkos newton on neigh half -in lammps.in

mv log.lammps log.lammps_8GPU_sym
