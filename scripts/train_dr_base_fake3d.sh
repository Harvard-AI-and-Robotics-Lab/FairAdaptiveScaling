#!/bin/bash
DATASET_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR10k_Data
RESULT_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR30k_results
MODEL_TYPE=( efficientnet ) # Options: efficientnet | vit | resnet | swin | vgg | resnext | wideresnet | efficientnetv1 | convnext
NUM_EPOCH=8
MODALITY_TYPE='oct_bscans' # Options: 'oct_bscans_3d' | 'slo_fundus'
ATTRIBUTE_TYPE=race # Options: race | gender | hispanic

# OPTIMIZER='adamw'
# OPTIMIZER_ARGUMENTS='{"lr": 0.001, "weight_decay": 0.01}'

# SCHEDULER='step_lr'
# SCHEDULER_ARGUMENTS='{"step_size": 30, "gamma": 0.1}'

if [ ${MODALITY_TYPE} = 'oct_bscans' ]; then
	LR=(1e-5) 
#     LR=( 1e-4 1e-5 1e-6 1e-7 )
	BATCH_SIZE=10
elif [ ${MODALITY_TYPE} = 'slo_fundus' ]; then
	LR=1e-4
# 	LR=( 1e-3 1e-4 1e-5 1e-6 1e-7 )
	BATCH_SIZE=10
else
	LR=1e-4
	BATCH_SIZE=6
fi


VIT_WEIGHTS=imagenet
BATCH_SIZE=6
BLR=5e-4
WD=0.
LD=0.55
DP=0.1

NEED_BALANCED=False
MODEL_TYPE=( vgg ) # ( efficientnet resnet swin convnext ViT-B vgg )
ATTRIBUTE_TYPE=( race )

for (( j=0; j<${#MODEL_TYPE[@]}; j++ ));
do
for (( a=0; a<${#ATTRIBUTE_TYPE[@]}; a++ ));
do
for (( i=0; i<${#LR[@]}; i++ ));
do
PERF_FILE=${MODEL_TYPE[$j]}_${MODALITY_TYPE}_${ATTRIBUTE_TYPE[$a]}_oversample.csv

if [ ${MODEL_TYPE[$j]} = 'ViT-B' ]; then
    # NEED_BALANCED=True
    NUM_EPOCH=20
fi

python ./scripts/train_dr_fair.py \
		--data_dir ${DATASET_DIR}/DR/ \
		--result_dir ${RESULT_DIR}/results_harvard10k/dr_${MODALITY_TYPE}_${ATTRIBUTE_TYPE[$a]}/${MODEL_TYPE[$j]}_${MODALITY_TYPE}_lr${LR[$i]}_bz${BATCH_SIZE}_oversample \
		--model_type  ${MODEL_TYPE[$j]} \
		--image_size 200 \
		--lr ${LR[$i]} \
        --weight-decay 0. --momentum 0.1 \
		--batch_size ${BATCH_SIZE} \
		--epochs ${NUM_EPOCH} \
		--modality_types ${MODALITY_TYPE} \
		--perf_file ${PERF_FILE} \
        --attribute_type ${ATTRIBUTE_TYPE[$a]} \
        --vit_weights ${VIT_WEIGHTS} \
        --blr ${BLR} \
        --drop_path ${DP} \
        --layer_decay ${LD} \
        --weight_decay ${WD} \
        --need_balance True
		# --optimizer ${OPTIMIZER} \
		# --optimizer_arguments ${OPTIMIZER_ARGUMENTS} \
		# --scheduler ${SCHEDULER} \
		# --scheduler_arguments ${SCHEDULER_ARGUMENTS}
done
done
done


# NEED_BALANCED=True
# MODEL_TYPE=( efficientnet resnet swin convnext ViT-B vgg )
# ATTRIBUTE_TYPE=( race )

# for (( j=0; j<${#MODEL_TYPE[@]}; j++ ));
# do
# for (( a=0; a<${#ATTRIBUTE_TYPE[@]}; a++ ));
# do
# for (( i=0; i<${#LR[@]}; i++ ));
# do
# PERF_FILE=${MODEL_TYPE[$j]}_${MODALITY_TYPE}_${ATTRIBUTE_TYPE[$a]}_oversample.csv

# if [ ${MODEL_TYPE[$j]} = 'ViT-B' ]; then
#     # NEED_BALANCED=True
#     NUM_EPOCH=10
# fi

# python ./scripts/train_dr_fair.py \
# 		--data_dir ${DATASET_DIR}/DR/ \
# 		--result_dir ${RESULT_DIR}/results_test/dr_${MODALITY_TYPE}_${ATTRIBUTE_TYPE[$a]}/${MODEL_TYPE[$j]}_${MODALITY_TYPE}_lr${LR[$i]}_bz${BATCH_SIZE}_oversample \
# 		--model_type  ${MODEL_TYPE[$j]} \
# 		--image_size 200 \
# 		--lr ${LR[$i]} \
#         --weight-decay 0. --momentum 0.1 \
# 		--batch_size ${BATCH_SIZE} \
# 		--epochs ${NUM_EPOCH} \
# 		--modality_types ${MODALITY_TYPE} \
# 		--perf_file ${PERF_FILE} \
#         --attribute_type ${ATTRIBUTE_TYPE[$a]} \
#         --vit_weights ${VIT_WEIGHTS} \
#         --blr ${BLR} \
#         --drop_path ${DP} \
#         --layer_decay ${LD} \
#         --weight_decay ${WD} \
#         --need_balance True
# 		# --optimizer ${OPTIMIZER} \
# 		# --optimizer_arguments ${OPTIMIZER_ARGUMENTS} \
# 		# --scheduler ${SCHEDULER} \
# 		# --scheduler_arguments ${SCHEDULER_ARGUMENTS}
# done
# done
# done