library(forecast)
library(caret)
require(xts)

## Read in training data attributes from CSV file
trainingDat <- read.csv(
  file = "training_task2_v2.2.csv",
  header = TRUE,
  stringsAsFactors = FALSE
)

# Factorize the sites
trainingDat$Site <- as.factor(trainingDat$Site)

time_index <- seq(from = as.POSIXct("2013-1-1 00:00"), to = as.POSIXct("2015-12-31 00:00"), by = "hour")

set.seed(1)

value <- rnorm(n = length(time_index))
eventdate <-

# Convert into date format
#trainingDat$Time <- as.Date(trainingDat$Time)

## Read in testing data attributes from CSV file
testingDat <- read.csv(
  file = "testing_task2_v1.csv",
  header = TRUE,
  stringsAsFactors = FALSE
)

# Factorize the sites
testingDat$Site <- as.factor(testingDat$Site)
