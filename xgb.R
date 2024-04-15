library(xgboost)
library(tidyverse)

setwd('C:/Users/clark/Documents/GitHub/kaggle-house-prices')

###
# run function definitions script
###


# read data and select only numeric columns
data = read_csv('train_cleaned_option2.csv') %>% 
  select(!c('...1', 'Id')) %>% 
  select(where(is.numeric))

# divide into 5 folds
fold_assn <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(data), replace=TRUE)
data = cbind(data, fold_assn)

# cross val
rmse_of_logs = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  print(f)
  
  datasets = fold_ttsplit(data, "SalePrice", f)
  print('datasets created')
  
  mod = xgboost(data = as.matrix(datasets[[1]]),
                label = log(datasets[[2]]$SalePrice),
                params = list(max_depth = 3),
                nrounds = 20,
                verbose = 0)
  
  print('model trained')
  
  y_hat = predict(object = mod, newdata = as.matrix(datasets[[3]]))
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (y_hat[i] - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  rmse_of_logs = append(rmse_of_logs, sqrt(SSE/test_len))
}

mod
rmse_of_logs

# mean: 0.1586175
mean(rmse_of_logs)


