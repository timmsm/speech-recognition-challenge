#!/usr/bin/Rscript

# Program: download-data.R
# Purpose: Download the competition data

library(tidyverse)

# Download and decompress data --------------------------------------------
if (!dir.exists("../data"))
  dir.create("../data")

"https://www.kaggle.com/c/tensorflow-speech-recognition-challenge/download/train.7z" %>% 
  download.file("../data/train.tar.gz")

untar("../data/train.tar.gz", "../data/train")
