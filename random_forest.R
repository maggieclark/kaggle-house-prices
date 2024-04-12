
# set up
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
data = read_csv('train_cleaned_option1.csv')

# imputed medians
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

datasets = ttsplit(model1data, "SalePrice")

# forest 1
randomForest(na.roughfix(datasets[[1]]),
             datasets[[2]]$SalePrice,
             xtest = na.roughfix(datasets[[3]]),
             ytest = datasets[[4]]$SalePrice,
             ntree=100, 
             importance=T)

# missing as factor level
model2data = data %>% 
  mutate(across(where(is.character), \(x) replace_na(x, "unknown"))) %>% 
  mutate(across(where(is.numeric), \(x) replace_na(x, -1)))

model2data = model2data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

datasets = ttsplit(model2data)

# forest
rf = randomForest(datasets[[1]],
                  datasets[[2]],
                  xtest = datasets[[3]],
                  ytest = datasets[[4]],
                  ntree=100, 
                  importance=T)

# importance plot

varImpPlot(rf)
