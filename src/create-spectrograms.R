library(phonTools)
library(tidyverse)

wav_files <- list.files("data/train", "wav$", full.names = TRUE, recursive = TRUE) %>% 
  stringr::str_conv("ASCII")

load_sound <- possibly(loadsound, otherwise = NULL)

wav_sounds <- map(wav_files, load_sound) %>% 
  set_names(wav_files) %>% 
  compact()

