#!/bin/bash

# Program: prep_aligner_data.sh
# Purpose: Rearrange training data for use with Montreal Forced Aligner

# Create output directory
if [ -d ../data/speakers ]
then
    rm -rf ../data/speakers
fi

mkdir ../data/speakers

# Create one directory per speaker
ls -R ../data/train/audio | 
    grep 'wav$' |
    sed -E 's/^([a-z0-9]{8})_.+/mkdir -p ../data/speakers\/\1/g' |
    sort -u | 
    grep 'speakers' |
    bash

# Populate speaker directories
for d in $(ls ../data/train/audio | grep -v '_background_noise_')
do
    for f in $(ls ../data/train/audio/$d)
    do
        # Create transcription labels
        echo $d > ../data/speakers/${f:0:8}/${f/wav/lab}

        # Copy audio data into speaker directories
        cp ../data/train/audio/$d/$f ../data/speakers/${f:0:8}/$f
    done
done

exit 0

