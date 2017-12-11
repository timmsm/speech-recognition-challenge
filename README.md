# speech-recognition-challenge
TensorFlow Speech Recognition Challenge

## Dependencies

* Install the following R packages:

`keras`
`tidyverse`

* Install the following Python packages using `pip`:

`matplotlib`
`numpy`
`praat-parselmouth`

* Within R, run the following code:

`keras::install_keras("gpu")`

## Running the project

* After cloning the repository, use `cd` to change directories into the `src` directory contained in the project.

* Run the following command for each program in the directory:

`chmod +x program.R/py`

* Run the programs in the following order:

`./download-data.R`
`./praat-spectrograms.py`
`./train-conv-network.R`
