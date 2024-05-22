#!/bin/bash
# # HAVO
DATASET_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR10k_Data
RESULT_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR30k_results

TASK=cls # md | tds | cls
LOSS_TYPE='bce' # mse | cos | kld | mae | gaussnll | bce 
LR=1e-4 
NUM_EPOCH=50 # 10
BATCH_SIZE=2 #( 10 12 14 16 18 20 ) best 6, best 18 for large scale 
STRETCH_RATIO=5 #( 0.5 1 2 5 10 26 ) # best 5
MODALITY_TYPE='oct_bscans_3d' # 'rpet' | 'fundus' | 'oct_bscans'
ATTRIBUTE_TYPE=gender # race|gender|hispanic
EXPR=train_predictor_dr

MODEL_TYPE=resnet18 
NEED_BALANCE=false
CONV_TYPE=Conv3d  
IMBALANCE_BETA=-1
SPLIT_RATIO=1 


PERF_FILE=${MODEL_TYPE}_${MODALITY_TYPE}_${ATTRIBUTE_TYPE}_3D_baseline_lr${LR}.csv

python ./scripts/train_dr_fair_real3d.py \
		--data_dir ${DATASET_DIR}/DR/ \
		--result_dir ${RESULT_DIR}/results_best/dr_${MODALITY_TYPE}_${ATTRIBUTE_TYPE}_${MODEL_TYPE}_${CONV_TYPE}_3D_baseline_lr${LR} \
		--model_type ${MODEL_TYPE} \
		--image_size 200 \
		--loss_type ${LOSS_TYPE} \
		--lr ${LR} --weight-decay 0. --momentum 0.1 \
		--batch_size ${BATCH_SIZE} \
		--task ${TASK} \
		--epochs ${NUM_EPOCH} \
		--modality_types ${MODALITY_TYPE} \
		--perf_file ${PERF_FILE} \
		--attribute_type ${ATTRIBUTE_TYPE} \
        --conv_type ${CONV_TYPE}
# 		--exp_name dr_${MODALITY_TYPE}_${ATTRIBUTE_TYPE}_3D_baseline_Conv_${CONV_TYPE}_Model_${MODEL_TYPE}_${MODALITY_TYPE}_Task${TASK}_lr${LR}_bz${BATCH_SIZE} 
# 		--need_balance ${NEED_BALANCE} \
		
