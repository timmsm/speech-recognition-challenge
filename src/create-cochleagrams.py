#!/usr/bin/env python2

# Program: create-cochleagrams.py
# Purpose: Create cochleagrams from training data for classification by CNNs

import brian2 as b2
import brian2.hears as bh
import numpy as np
import os

# Find all training sound files
wav_files = []
for d in os.listdir("../data/train/audio"):
    for f in os.listdir(os.path.join("../data/train/audio", d)):
        if f[-3:] == "wav":
            wav_files.append(os.path.join("../data/train/audio", d, f))

# Create output directory if it doesn't exist
if not os.path.isdir("../data/cochleagrams"):
    os.makedirs("../data/cochleagrams")

# Define ERB space
cf = bh.erbspace(20 * b2.Hz, 20 * b2.kHz, 100)

# Create cochleagrams
wf = wav_files[1]
#for wf in wav_files:
    
# Read wav file
sound = bh.loadsound(wf)
sound = [s.extended(16000 - s.nsamples) for s in sound]

sound = bh.Sound(sound)
# Calculate cochleagram from audio

gammatone = bh.Gammatone(sound, cf) #for s in sound
del sound # Free memory

def foo(*args): 
    return b2.clip(args, 0, b2.Inf)**(1.0/3.0)

bar = [foo] * 10

cochlea = bh.FunctionFilterbank(gammatone, lambda x: b2.clip(x, 0, b2.Inf)**(1.0/3.0))
del gammatone

lowpass = bh.LowPass(cochlea, 10 * b2.Hz)
del cochlea

cochleagram = lowpass.process()
del lowpass

# Plot and save as png
name = wf.replace("../data/train/audio/", "")\
    .replace("/", "_").replace("wav", "png")
    
b2.imshow(cochleagram.T, origin='lower left', aspect='auto', vmin=0)
fig.write_png(os.path.join("../data/cochleagrams", name))
del fig, cochleagram
