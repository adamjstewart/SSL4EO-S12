#!/usr/bin/env bash

# slurm job configuration
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --output=srun_outputs/classification/SS_moco_LC_rn50_10_%j.out
#SBATCH --error=srun_outputs/classification/SS_moco_LC_rn50_10_%j.err
#SBATCH --time=01:00:00
#SBATCH --job-name=SS_lc_moco
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=10
#SBATCH --partition=develbooster

master_node=${SLURM_NODELIST:0:9}${SLURM_NODELIST:10:4}
dist_url="tcp://"
dist_url+=$master_node
dist_url+=:40000


# load required modules
module load Stages/2022
module load GCCcore/.11.2.0
module load Python

# activate virtual environment
source /p/project/hai_dm4eo/wang_yi/env2/bin/activate


# define available gpus
export CUDA_VISIBLE_DEVICES=0,1,2,3

# run script as slurm job
srun python -u linear_SS_moco.py \
--data_dir /p/scratch/hai_ssl4eo/data/so2sat-lcz42 \
--bands B13 \
--checkpoints_dir /p/project/hai_ssl4eo/wang_yi/ssl4eo-s12-dataset/src/benchmark/fullset_temp/checkpoints/moco_lc/SS_rn50_10 \
--backbone resnet50 \
--train_frac 0.1 \
--batchsize 64 \
--lr 8 \
--schedule 60 80 \
--epochs 100 \
--num_workers 10 \
--seed 42 \
--dist_url $dist_url \
--pretrained /p/project/hai_ssl4eo/wang_yi/ssl4eo-s12-dataset/src/benchmark/fullset_temp/checkpoints/moco/B13_rn50/checkpoint_0099.pth.tar \
--in_size 224 \
#--normalize \
