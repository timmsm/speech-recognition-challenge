#!/usr/bin/env python3

# Program: create-mfcc-data.py
# Purpose: Create MFCC-based training data for phoneme classification

from python_speech_features import mfcc, delta
import numpy as np
import os
import pandas as pd
import scipy.io.wavfile as wav

# Find all training data wav files
wav_files = []
for d in os.listdir(path="../data/speakers"):
    for f in os.listdir(path=os.path.join("../data/speakers", d)):
        if f[-3:] == "wav":
            wav_files.append(os.path.join("../data/speakers", d, f))
            
# Read wav files
wav_audio = [wav.read(x) for x in wav_files]

# Pad short files with zeros
def pad_sig(sig, rate):
    return np.pad(sig, (0, rate - len(sig)), 'constant')

wav_audio = [(rate, pad_sig(sig, rate)) for rate, sig in wav_audio]

# Create mfccs, deltas, and delta-deltas
mfccs = [mfcc(sig, rate) for rate, sig in wav_audio]
deltas = [delta(m, 2) for m in mfccs]
delta_deltas = [delta(d, 2) for d in deltas]

del wav_audio # Free memory

# Combine features into a single DataFrame
features = []
for f in [mfccs, deltas, delta_deltas]:
    features.append(pd.concat([pd.DataFrame(x) for x in f]))

del mfccs, deltas, delta_deltas # Free memory

features = pd.concat(features, axis=1)

# Add file names and start times to features DataFrame
frame_files = []
frame_start = []
for f in wav_files:
    tg = f.replace("speakers", "alignments").replace("wav", "TextGrid")
    for i in range(99):
        frame_files.append(tg)
        frame_start.append(i / 100.0)
        
features["file"] = frame_files
features["time"] = frame_start

features = features.set_index(["file", "time"])

del frame_files, frame_start

# Add phoneme labels to features DataFrame
phoneme_labels = pd.read_csv("../data/complete_labels.csv") 
phoneme_labels = phoneme_labels.set_index(["file", "time"])

features = pd.merge(features, phoneme_labels, left_index=True, right_index=True) 

# Write features dataset to csv file
features.to_csv("../data/mfcc-phonemes.csv")
