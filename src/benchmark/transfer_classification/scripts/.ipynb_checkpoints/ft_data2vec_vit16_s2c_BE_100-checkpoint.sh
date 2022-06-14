OMP_NUM_THREADS=1 python -m torch.distributed.launch --nproc_per_node=4 linear_BE_data2vec.py \
        --model beit_small_patch16_224 \
        --finetune /p/project/hai_ssl4eo/nassim/data2vec/experiments/data2vec/pretrain/output/checkpoint-99.pth \
        --train_frac 1.0 \
        --data_path '/p/scratch/hai_ssl4eo/data/bigearthnet/BigEarthNet_LMDB_uint8' \
        --output_dir '/p/project/hai_ssl4eo/wang_yi/ssl4eo-s12-dataset/src/benchmark/fullset_temp/checkpoints/data2vec_ft/BE_vits16' --log_dir '/p/project/hai_ssl4eo/wang_yi/ssl4eo-s12-dataset/src/benchmark/fullset_temp/checkpoints/data2vec_ft/BE_vits16/logs' \
        --batch_size 64 --lr 1e-3 --update_freq 1 \
        --warmup_epochs 10 --epochs 100 --layer_decay 0.65 --drop_path 0.2 --drop 0.0 \
        --weight_decay 0.0001 --nb_classes 19 \
        --target_layer -1 --world_size 1 --dist_url 'tcp://localhost:10002'