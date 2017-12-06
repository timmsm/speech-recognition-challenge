# Program: create-spectrograms.R
# Purpose: Read all wav files from the train directory and save their corresponding
#          spectrograms in the img directory

library(seewave)
library(tidyverse)

# Read wav files ----------------------------------------------------------
wav_files <- list.files("data/train/audio", "wav$", full.names = TRUE, recursive = TRUE)

wav_sounds <- map(wav_files, tuneR::readWave) %>% 
  set_names(str_replace_all(wav_files, c("^data" = "img", "wav$" = "png")))

# Create destination directories ------------------------------------------
dest_dirs <- list.dirs("data/train/audio") %>% 
  str_replace("data", "img")

for (dd in dest_dirs) {
  if (!dir.exists(dd))
    dir.create(dd, recursive = TRUE)
}

# Save spectrograms -------------------------------------------------------
save_spectro <- function(sound, filename) {
  png(filename, width = 4, height = 4, units = 'in', res = 300)
  spectro(
    sound, scale = FALSE, tlab = "", flab = "", axisX = FALSE, 
    axisY = FALSE, palette = reverse.gray.colors.2, colgrid = "transparent", 
    colaxis = FALSE, tlim = c(0, 1), flim = c(0, 6)
  )
  graphics.off()
}

save_spectro_ <- safely(save_spectro, NULL)

iwalk(wav_sounds, save_spectro_)
