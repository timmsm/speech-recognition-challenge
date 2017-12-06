# Program: train-conv-network.R
# Purpose: Train a Convolutional Network to recognize command words

library(keras)
library(tidyverse)

# Generate augmented training data ----------------------------------------
train_generator <- image_data_generator(
  samplewise_center = TRUE, 
  samplewise_std_normalization = TRUE, 
  # zca_whitening = TRUE,
  width_shift_range = 0.1,
  height_shift_range = 0.1,
  zoom_range = 0.2
) %>% 
  flow_images_from_directory(
    "data/spectrograms",  ., seed = 3521
  )

# Fit convolutional network -----------------------------------------------
cnn <- keras_model_sequential()

cnn %>% 
  layer_conv_2d(filters = 50, kernel_size = 2, activation = "relu", input_shape = c(256, 256, 3)) %>% 
  layer_max_pooling_2d() %>% 
  layer_conv_2d(filters = 50, kernel_size = 2, activation = "relu") %>% 
  layer_max_pooling_2d() %>% 
  layer_flatten() %>% 
  layer_dense(units = 30, activation = "softmax")

cnn %>% 
  compile(
    loss      = "categorical_crossentropy",
    optimizer = optimizer_adam(),
    metrics   = "accuracy"
  )

cnn %>% 
  fit_generator(train_generator, 58251 / 32, epochs = 50)
