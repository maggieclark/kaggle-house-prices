
### set up ###
library(tidyverse)
library(randomForest)

setwd('C:/Users/clark/Documents/GitHub/kaggle-house-prices')


# define functions
ttsplit = function(prepped_data, outcome_column){
  
  sample <- sample(c(TRUE, FALSE), nrow(prepped_data), replace=TRUE, prob=c(0.7,0.3))
  train  <- prepped_data[sample, ]
  test   <- prepped_data[!sample, ]
  
  Xtrain = train %>% 
    select(!outcome_column)
  
  ytrain = train %>% 
    select(outcome_column)
  
  Xtest = test %>% 
    select(!outcome_column)
  
  ytest = test %>% 
    select(outcome_column)
  
  return(list(Xtrain, ytrain, Xtest, ytest))
}


# read data
data = read_csv('train_cleaned_minimal.csv')

### imputed medians ###
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

datasets = ttsplit(model1data, "SalePrice")

# forest 1
rf1 = randomForest(na.roughfix(datasets[[1]]),
             datasets[[2]]$SalePrice,
             xtest = na.roughfix(datasets[[3]]),
             ytest = datasets[[4]]$SalePrice,
             ntree=100, 
             importance=T)

# RMSE of logs
test_len = nrow(datasets[[4]])

SSE = 0

for (i in 1:test_len){
  ith_SE = (log(rf1[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
  SSE = SSE + ith_SE
}

sqrt(SSE/test_len)

# importance

varImpPlot(rf1)


### missing as factor level ###
model2data = data %>% 
  mutate(across(where(is.character), \(x) replace_na(x, "unknown"))) %>% 
  mutate(across(where(is.numeric), \(x) replace_na(x, -1)))

model2data = model2data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

datasets = ttsplit(model2data, "SalePrice")

# forest
rf2 = randomForest(datasets[[1]],
             datasets[[2]]$SalePrice,
             xtest = datasets[[3]],
             ytest = datasets[[4]]$SalePrice,
             ntree=500, 
             importance=T)

# RMSE of logs
test_len = nrow(datasets[[4]])

SSE = 0

for (i in 1:test_len){
  ith_SE = (log(rf2[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
  SSE = SSE + ith_SE
}

sqrt(SSE/test_len)


# importance plot

varImpPlot()
