#!/usr/bin/Rscript

library(tidyverse)

read_csv("../data/labels.csv") %>% 
  mutate(xmax = factor(xmax, levels = seq(0, .98, 0.01))) %>% 
  group_by(file) %>% 
  complete(xmax) %>% 
  ungroup() %>% 
  fill(text, .direction = "up") %>% 
  select(file, time = xmax, phoneme = text) %>% 
  drop_na() %>% 
  write_csv("../data/complete_labels.csv")
