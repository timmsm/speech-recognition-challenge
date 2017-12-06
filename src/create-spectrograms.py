#!/usr/bin/env python3

# Program: create-spectrograms.py
# Purpose: Create spectrograms from command word audio

from functools import partial
from scipy.signal import spectrogram
import matplotlib.pyplot as plt
import os
import scipy.io.wavfile as wf

# Find audio files and create output directories
wav_files = []
for d in os.listdir(path="../data/train/audio"):
    if d != "_background_noise_":
        if not os.path.isdir(os.path.join("../data/spectrograms", d)):
            os.makedirs(os.path.join("../data/spectrograms", d))
        for f in os.listdir(path=os.path.join("../data/train/audio", d)):
            wav_files.append(os.path.join("../data/train/audio", d, f))
    
# Read audio files
wav_audio = map(lambda x: wf.read(x), [wav_files[0]])

# Create spectrograms
spectro = partial(spectrogram, fs)
sgrams = map(lambda x: spectrogram(x[1], x[0]), wav_audio)
splots = map(lambda x: plt.imshow(x[2]), sgrams)

# Save spectrograms
output_files = []
for f in wav_files:
    o = f.replace("train/audio", "spectrograms").replace("wav", "png")
    output_files.append(o)
    
for s, f in zip(splots, output_files):
    s.write_png(f)
    