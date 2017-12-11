#!/usr/bin/Rscript

# Program: train-conv-network.R
# Purpose: Train a Convolutional Network to recognize command words

library(keras)
library(tidyverse)

# Generate augmented training data ----------------------------------------
train_generator <- image_data_generator(
  samplewise_center = TRUE, 
  samplewise_std_normalization = TRUE, 
  width_shift_range = 0.1,
  height_shift_range = 0.1
) %>% 
  flow_images_from_directory(
    "../train",  ., seed = 4620, batch_size = 32, target_size = c(640, 480)
  )

validation_generator <- image_data_generator(
  samplewise_center = TRUE, 
  samplewise_std_normalization = TRUE, 
  width_shift_range = 0.1,
  height_shift_range = 0.1
) %>% 
  flow_images_from_directory(
    "../validation",  ., seed = 4620, batch_size = 32, target_size = c(640, 480)
  )

# Fit convolutional network -----------------------------------------------
cnn <- keras_model_sequential()

cnn %>% 
  layer_conv_2d(filters = 16, kernel_size = 2, activation = "elu", input_shape = c(640, 480, 3)) %>% 
  layer_conv_2d(filters = 16, kernel_size = 2, activation = "elu") %>% 
  layer_max_pooling_2d() %>% 
  layer_dropout(0.2) %>% 
  layer_conv_2d(filters = 32, kernel_size = 3, activation = "elu") %>% 
  layer_conv_2d(filters = 32, kernel_size = 3, activation = "elu") %>% 
  layer_max_pooling_2d() %>% 
  layer_dropout(0.2) %>% 
  layer_conv_2d(filters = 64, kernel_size = 3, activation = "elu") %>% 
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

training_history <- cnn %>% 
  fit_generator(train_generator, 20000 / 32, epochs = 6)

# Evaluate CNN ------------------------------------------------------------
eval_results <- cnn %>% 
  evaluate_generator(validation_generator, steps = 300)

# Save model --------------------------------------------------------------
save_model_hdf5(cnn, "../convnet.hdf5")
write_rds(training_history, "../training_history.rds")
write_rds(eval_results, "../eval_results.rds")
