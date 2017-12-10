# Program: create-training-data.R
# Purpose: Create cepstrum based training data set for phoneme classification

library(tuneR)
library(tidyverse)

# Find wav files ----------------------------------------------------------
audio_files <- list.files(
  "data/train/audio", "wav$", full.names = TRUE, recursive = TRUE
) %>% 
  grep("background", ., invert = TRUE, value = TRUE)

# Create cepstrums --------------------------------------------------------
get_cepstrums <- function(file, ...) {
  readWave(file) %>% 
    melfcc(numcep = 15, minfreq = 20, ...) %>% 
    as_tibble() %>% 
    add_column(file = file)
}

cepstrums <- map_dfr(audio_files, get_cepstrums) %>% 
  mutate_if(is.numeric, scale)
