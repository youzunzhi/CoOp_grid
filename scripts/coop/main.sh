#!/bin/bash

# custom config
DATA=data
TRAINER=CoOp

DATASET=oxford_pets
CFG=vit_l14_336 # config file
CTP=end  # class token position (end or middle)
NCTX=16  # number of context tokens
SHOTS=16  # number of shots (1, 2, 4, 8, 16)
CSC=False  # class-specific context (False or True)
GRID_N=3
TOTAL_TRAIN_BATCHES=400

#for SEED in 1 2 3
for SEED in 1
do
    DIR=output/${DATASET}/${TRAINER}/${CFG}_${SHOTS}shots/nctx${NCTX}_csc${CSC}_ctp${CTP}_${GRID_N}x${GRID_N}/seed${SEED}
    if [ -d "$DIR" ]; then
        echo "Oops! The results exist at ${DIR} (so skip this job)"
        echo "Remove this directory? (y/n)"
        read answer
        if [ "$answer" = "y" ]; then
            rm -rf ${DIR}
            python train.py \
            --root ${DATA} \
            --seed ${SEED} \
            --trainer ${TRAINER} \
            --dataset-config-file configs/datasets/${DATASET}.yaml \
            --config-file configs/trainers/${TRAINER}/${CFG}.yaml \
            --output-dir ${DIR} \
            --grid_n ${GRID_N} \
            --total_train_batches ${TOTAL_TRAIN_BATCHES} \
            TRAINER.COOP.N_CTX ${NCTX} \
            TRAINER.COOP.CSC ${CSC} \
            TRAINER.COOP.CLASS_TOKEN_POSITION ${CTP} \
            DATASET.NUM_SHOTS ${SHOTS}
        fi
    else
#        echo
        python train.py \
        --root ${DATA} \
        --seed ${SEED} \
        --trainer ${TRAINER} \
        --dataset-config-file configs/datasets/${DATASET}.yaml \
        --config-file configs/trainers/${TRAINER}/${CFG}.yaml \
        --output-dir ${DIR} \
        --grid_n ${GRID_N} \
        --total_train_batches ${TOTAL_TRAIN_BATCHES} \
        TRAINER.COOP.N_CTX ${NCTX} \
        TRAINER.COOP.CSC ${CSC} \
        TRAINER.COOP.CLASS_TOKEN_POSITION ${CTP} \
        DATASET.NUM_SHOTS ${SHOTS}
    fi
done