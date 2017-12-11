#!/usr/bin/Rscript
# Program: train-conv-network.R
# Purpose: Train a Convolutional Network to recognize command words

library(keras)
library(tidyverse)

# Train CNNs for command words --------------------------------------------
# commands <- c("yes", "no", "up", "down", "left", "right", "on", "off", "stop", "go")

# for (com in commands) {
  # Generate augmented training data ----------------------------------------
train_generator <- image_data_generator() %>% 
  flow_images_from_directory(
    "train", ., seed = 4620, batch_size = 32, target_size = c(800, 800)
  )

valid_generator <- image_data_generator() %>% 
  flow_images_from_directory(
    "validation", ., seed = 4620, batch_size = 32, target_size = c(800 ,800)
  )

# Fit convolutional network -----------------------------------------------
cnn <- keras_model_sequential()

cnn %>% 
  layer_conv_2d(filters = 16, kernel_size = 2, activation = "relu", input_shape = c(800, 800, 3)) %>% 
  layer_conv_2d(filters = 16, kernel_size = 2, activation = "elu") %>% 
  layer_max_pooling_2d() %>% 
  layer_dropout(0.2) %>% 
  layer_conv_2d(filters = 32, kernel_size = 3, activation = "elu") %>% 
  layer_conv_2d(filters = 32, kernel_size = 3, activation = "elu") %>% 
  layer_max_pooling_2d() %>% 
  layer_dropout(0.2) %>% 
  layer_conv_2d(filters = 64, kernel_size = 3, activation = "relu") %>% 
  layer_max_pooling_2d() %>% 
  layer_dropout(0.2) %>% 
  layer_flatten() %>% 
  layer_batch_normalization(trainable = TRUE) %>% 
  layer_dense(units = 10, activation = "softmax")

cnn %>% 
  compile(
    loss      = "categorical_crossentropy",
    optimizer = optimizer_adam(),
    metrics   = "categorical_accuracy"
  )

model_history <- cnn %>% 
  fit_generator(train_generator, 560, epochs = 6)

# Validate network --------------------------------------------------------
cnn %>% 
  evaluate_generator(generator = valid_generator, step = 200)

# Save models -------------------------------------------------------------
save_model_hdf5(cnn, sprintf("models/%s.hdf5", "cnn"))
write_rds(model_history, sprintf("models/%s_plot.rds", "cnn"))

