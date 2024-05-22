#!/bin/bash
DATASET_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR10k_Data
RESULT_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR30k_results
TASK=cls # md | tds | cls
LOSS_TYPE='bce' # mse | cos | kld | mae | gaussnll | bce 
LR=5e-5 # 5e-5 for rnflt | 1e-4 for ilm
NUM_EPOCH=30 # 10
BATCH_SIZE=2 #( 10 12 14 16 18 20 ) best 6, best 18 for large scale 
STRETCH_RATIO=5 #( 0.5 1 2 5 10 26 ) # best 5
MODALITY_TYPE='oct_bscans_3d' # 'rpet' | 'fundus' | 'oct_bscans'
ATTRIBUTE_TYPE=race # race|gender|hispanic
PROGRESSION_TYPE=progression_outcome_md_fast_no_p_cut # ( progression_outcome_td_pointwise_no_p_cut progression_outcome_md_fast_no_p_cut )

MODEL_TYPE=( vgg16 ) # efficientnet | vit | resnet | swin | vgg | resnext | wideresnet | efficientnetv1 | convnext
NEED_BALANCE=false
CONV_TYPE=( Conv3d ) # ( Conv3d Conv2_5d ACSConv ) 
IMBALANCE_BETA=0.9999
IMBALANCE_BETA=-1
for (( j=0; j<${#MODEL_TYPE[@]}; j++ ));
do
for (( q=0; q<${#CONV_TYPE[@]}; q++ ));
do

PERF_FILE=${MODEL_TYPE[$j]}_${MODALITY_TYPE}_${CONV_TYPE[$q]}_${ATTRIBUTE_TYPE}_3D_adv.csv

python ./scripts/train_dr_fair_real3d_adv.py \
		--data_dir ${DATASET_DIR}/DR/ \
		--result_dir ${RESULT_DIR}/results_real3d/dr_${MODALITY_TYPE}_${ATTRIBUTE_TYPE}_${MODEL_TYPE[$j]}_${CONV_TYPE[$q]}_3D_adv \
		--model_type ${MODEL_TYPE[$j]} \
		--image_size 200 \
		--loss_type ${LOSS_TYPE} \
		--lr ${LR} --weight-decay 0. --momentum 0.1 \
		--batch_size ${BATCH_SIZE} \
		--task ${TASK} \
		--epochs ${NUM_EPOCH} \
		--modality_types ${MODALITY_TYPE} \
		--perf_file ${PERF_FILE} \
		--attribute_type ${ATTRIBUTE_TYPE} \
		--need_balance ${NEED_BALANCE} \
		--conv_type ${CONV_TYPE[$q]} 
		
done
done