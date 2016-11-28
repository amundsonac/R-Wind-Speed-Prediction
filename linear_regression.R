## libraries
require(readr)
require(xgboost)
require(Matrix)
require(data.table)
if (!require('vcd')) {
  install.packages('vcd')
  require(vcd)
}
library(caret)
library(scales)

## Read in training data attributes from CSV file
trainingDat <- read.csv(
  file = "training_task2.csv",
  header = TRUE,
  stringsAsFactors = FALSE
)

#trainingLabels <- rescale(trainingDat[,'AVG.WS'], to=c(0,1))
#trainingDat <- subset(trainingDat, select = -c(AVG.WS))

## Read in testing data attributes from CSV file
testingDat <- read.csv(
  file = "testing_task2.csv",
  header = TRUE,
  stringsAsFactors = FALSE
)

#testingLabels <- rescale(testingDat[,'AVG.WS'], to=c(0,1))
#testingDat <- subset(testingDat, select = -c(AVG.WS))

## Transform into data table
training <- data.table(trainingDat, keep.rownames = F)
testing <- data.table(testingDat, keep.rownames = F)

options(na.action = 'na.pass')

x <- sparse.model.matrix(~ . - 1, data = training[,-c('AVG.WS'), with = F])

options(na.action = 'na.omit')

y <- training[,AVG.WS]

d_train <- xgb.DMatrix(data = x, label = y, missing = NA)

options(na.action = 'na.pass')
testX <- sparse.model.matrix(~ . - 1, data =testing[,-c('AVG.WS'), with = F])
options(na.action = 'na.omit')

testY <- testing[,AVG.WS]

d_test <- xgb.DMatrix(data = testX, label = testY, missing = NA)

params <- list(
  objective = 'reg:linear',
  eval_metric = 'rmse',
  max_depth = 25,
  eta = 0.3
)

linReg <- xgboost(data = d_train,
                  params = params,
                  maximize = FALSE,
                  watchlist = list(eval = d_test, train = d_train),
                  nrounds = 25)

pred <- predict(linReg, d_test)

rmse <- sqrt(sum(mean((testY - pred)^2)))
mse <- sum(mean((testY - pred)^2))

