library(seewave)
library(tuneR)
library(tidyverse)

# Read wav files ----------------------------------------------------------
wav_files <- list.files("data/train/audio", "wav$", full.names = TRUE, recursive = TRUE)

wav_sounds <- map(wav_files, readWave)

# Create destination directories ------------------------------------------
dest_dirs <- list.dirs("data/train/audio") %>% 
  str_replace("train/audio", "spectrograms")

for (dd in dest_dirs) {
  if (!dir.exists(dd))
    dir.create(dd, recursive = TRUE)
}

# Filter to human voice range ---------------------------------------------
filtered_speech <- wav_sounds %>%  
  map(bwfilter, f = 16000, from = 300, to = 3400, bandpass = TRUE, output = "Wave") %>% 
  set_names(str_replace_all(wav_files, c("train/audio" = "spectrograms", "wav$" = "png")))

# Create and save spectrogram ---------------------------------------------
save_spectro <- function(sound, filename) {
  png(filename, width = 4, height = 4, units = "in", res = 300)
  spectro(
    sound, scale = FALSE, tlab = "", flab = "", axisX = FALSE, 
    axisY = FALSE, colgrid = "transparent", 
    colaxis = FALSE, tlim = c(0, 1), flim = c(0, 4)
  )
  graphics.off()
}

save_spectro_ <- safely(save_spectro, NULL)

iwalk(filtered_speech, save_spectro_)
