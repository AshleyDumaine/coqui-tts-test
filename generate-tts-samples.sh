#!/bin/bash
set -euo pipefail

OUTPUT_DIR=audio-samples
INPUT_TEXT="$(cat sample.txt)"

mkdir -p "${OUTPUT_DIR}"

en_models=$(tts --list_models | grep -oP '(?<=tts_models/en/).*' | awk '{print $1}')
for model in $en_models; do
    # create subdir if needed
    mkdir -p "${OUTPUT_DIR}/$(echo ${model} |  cut -d/ -f1)"
    # generate audio file
    if [[ "$model" == "vctk"* ]]; then
	# need a speaker index for multi-speaker models
	SPEAKER_IDX=$(tts --model_name "tts_models/en/${model}" --list_speaker_idxs | awk 'END {print $3}' | tr -d "'" | tr -d ":")
	# vctk/fast_pitch complains about cuda devices so just run these on the cpu
	tts --model_name tts_models/en/$model --out_path "${OUTPUT_DIR}/${model}-${SPEAKER_IDX}-sample.wav" --text "${INPUT_TEXT}" --speaker_idx "${SPEAKER_IDX}"
    else
        tts --model_name tts_models/en/$model --out_path "${OUTPUT_DIR}/${model}-sample.wav" --use_cuda True --text "${INPUT_TEXT}"
    fi
done
