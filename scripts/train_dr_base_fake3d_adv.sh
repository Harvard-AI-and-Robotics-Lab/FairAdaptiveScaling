#!/bin/bash
DATASET_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR10k_Data
RESULT_DIR=/data/home/shim/pyspace/others/pyspace/ICLR_30k/Harvard-DR30k_results
MODEL_TYPE=( efficientnet ) # Options: efficientnet | vit | resnet | swin | vgg | resnext | wideresnet | efficientnetv1 | convnext
NUM_EPOCH=10
MODALITY_TYPE='oct_bscans' # Options: 'oct_bscans_3d' | 'slo_fundus'
ATTRIBUTE_TYPE=race # Options: race | gender | hispanic

# OPTIMIZER='adamw'
# OPTIMIZER_ARGUMENTS='{"lr": 0.001, "weight_decay": 0.01}'

# SCHEDULER='step_lr'
# SCHEDULER_ARGUMENTS='{"step_size": 30, "gamma": 0.1}'

if [ ${MODALITY_TYPE} = 'oct_bscans' ]; then
	LR=1e-4
	BATCH_SIZE=6
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

# NEED_BALANCED=True
MODEL_TYPE=( ViT-B ) # ( efficientnet resnet swin convnext ViT-B vgg )
ATTRIBUTE_TYPE=( gender_ethnicity ) # ( race gender ethnicity maritalstatus language gender_race gender_ethnicity )

for (( j=0; j<${#MODEL_TYPE[@]}; j++ ));
do
for (( a=0; a<${#ATTRIBUTE_TYPE[@]}; a++ ));
do


if [ ${MODEL_TYPE[$j]} = 'ViT-B' ]; then
    # NEED_BALANCED=True
    NUM_EPOCH=10
fi

if [ ${MODEL_TYPE[$j]} = 'vgg' ]; then
    # NEED_BALANCED=True
    LR=1e-5
    WD=0.001
    BATCH_SIZE=32
fi


PERF_FILE=${MODEL_TYPE[$j]}_${MODALITY_TYPE}_${ATTRIBUTE_TYPE[$a]}_adv.csv

python ./scripts/train_dr_fair_adv.py \
		--data_dir ${DATASET_DIR}/DR/ \
		--result_dir ${RESULT_DIR}/results_harvard10k/dr_oct_bscans_adversarial/dr_${MODALITY_TYPE}_${ATTRIBUTE_TYPE[$a]}/${MODEL_TYPE[$j]}_${MODALITY_TYPE}_lr${LR}_bz${BATCH_SIZE}_adv \
		--model_type ${MODEL_TYPE[$j]} \
		--image_size 200 \
		--lr ${LR} --weight-decay 0. --momentum 0.1 \
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
#         --need_balance ${NEED_BALANCED}
		# --optimizer ${OPTIMIZER} \
		# --optimizer_arguments ${OPTIMIZER_ARGUMENTS} \
		# --scheduler ${SCHEDULER} \
		# --scheduler_arguments ${SCHEDULER_ARGUMENTS}
done
done