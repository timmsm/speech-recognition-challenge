#!/usr/bin/env python3

# Program: create-train-test-sets.py
# Purpose: Split phoneme data into training/testing sets for classification

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, MinMaxScaler
import pandas as pd

# Read phoneme data
phonemes = pd.read_csv("../data/mfcc-phonemes.csv")

# Convert phoneme labels to integers
phonemes["phoneme"] = pd.Categorical(phonemes["phoneme"]).codes

# Split into train/test sets
X = phonemes.drop("phoneme", axis=1)
y = phonemes["phoneme"]

x_train, x_test, y_train, y_test = train_test_split(
        X, y, train_size=0.8, random_state=5231, stratify=y
        )

# Scale datasets
center = StandardScaler()
min_max = MinMaxScaler(feature_range=(-1, 1))

x_train = center.fit_transform(x_train)
x_test = center.fit_transform(x_test)

x_train = min_max.fit_transform(x_train)
x_test = min_max.fit_transform(x_test)

# Write test/train sets to csv files
pd.DataFrame(x_train).to_csv("../data/network-data/x_train.csv", index=False)
pd.DataFrame(y_train).to_csv("../data/network-data/y_train.csv", index=False)
pd.DataFrame(x_test).to_csv("../data/network-data/x_test.csv", index=False)
pd.DataFrame(y_test).to_csv("../data/network-data/y_test.csv", index=False)
