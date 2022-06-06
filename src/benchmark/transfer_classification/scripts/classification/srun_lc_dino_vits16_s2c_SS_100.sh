#!/usr/bin/env bash

# slurm job configuration
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --output=srun_outputs/classification/SS_dino_LC_vits16_100_%j.out
#SBATCH --error=srun_outputs/classification/SS_dino_LC_vits16_100_%j.err
#SBATCH --time=04:00:00
#SBATCH --job-name=SS_LC_dino
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=10
#SBATCH --partition=booster

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
srun python -u linear_SS_dino.py \
--data_dir /p/scratch/hai_ssl4eo/data/so2sat-lcz42 \
--bands B13 \
--checkpoints_dir /p/project/hai_ssl4eo/wang_yi/ssl4eo-s12-dataset/src/benchmark/fullset_temp/checkpoints/dino_lc/SS_vits16_100 \
--arch vit_small \
--patch_size 16 \
--train_frac 1.0 \
--batch_size_per_gpu 64 \
--lr 0.01 \
--epochs 100 \
--num_workers 10 \
--seed 42 \
--dist_url $dist_url \
--pretrained /p/project/hai_ssl4eo/wang_yi/ssl4eo-s12-dataset/src/benchmark/fullset_temp/checkpoints/dino/B13_vits16_224/checkpoint.pth \