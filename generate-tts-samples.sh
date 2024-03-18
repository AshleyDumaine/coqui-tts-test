#!/bin/bash
set euxo pipefail

OUTPUT_DIR=audio-samples
INPUT_TEXT="$(cat sample.txt)"

mkdir -p "${OUTPUT_DIR}"

en_models=$(tts --list_models | grep -oP '(?<=tts_models/en/).*' | awk '{print $1}')
for model in $en_models; do
    # create subdir if needed
    mkdir -p "${OUTPUT_DIR}/$(echo ${model} |  cut -d/ -f1)"
    # generate audio file
    tts --model_name tts_models/en/$model --out_path "${OUTPUT_DIR}/${model}-sample.wav" --use_cuda True --text "${INPUT_TEXT}"
done
