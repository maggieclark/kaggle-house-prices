
########################### set up #########################
library(tidyverse)
library(randomForest)

setwd('C:/Users/clark/Documents/GitHub/kaggle-house-prices')



######################### minimally processed ##############################

# read data
data = read_csv('train_cleaned_minimal.csv') %>% 
  select(!c('...1', 'Id'))

# divide into 5 folds
fold_assn <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(data), replace=TRUE)
data = cbind(data, fold_assn)


### imputed medians ###
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  
  datasets = fold_ttsplit(model1data, "SalePrice", f)
  print('datasets created')
  
  rf1 = randomForest(na.roughfix(datasets[[1]]),
                     datasets[[2]]$SalePrice,
                     xtest = na.roughfix(datasets[[3]]),
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     importance=T)
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf1[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

metrics

# mean of imputed medians with minimally processed data: 0.1672828
mean(metrics)

# importance

varImpPlot(rf1)


### missing as factor level ###
model2data = data %>% 
  mutate(across(where(is.character), \(x) replace_na(x, "unknown"))) %>% 
  mutate(across(where(is.numeric), \(x) replace_na(x, -99)))

model2data = model2data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  
  datasets = fold_ttsplit(model2data, "SalePrice", f)
  print('datasets created')
  
  rf2 = randomForest(datasets[[1]],
                     datasets[[2]]$SalePrice,
                     xtest = datasets[[3]],
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     importance=T)
  
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf2[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

metrics

# mean of missing as factor level with minimally processed data: 0.1662553
mean(metrics)

# importance plot

varImpPlot()


############ with some feature engineering ###########################

# read data
data = read_csv('train_cleaned_option1.csv') %>% 
  select(!c('...1', 'Id'))

# divide into 5 folds
fold_assn <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(data), replace=TRUE)
data = cbind(data, fold_assn)


### imputed medians ###
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  
  datasets = fold_ttsplit(model1data, "SalePrice", f)
  print('datasets created')
  
  rf1 = randomForest(na.roughfix(datasets[[1]]),
                     datasets[[2]]$SalePrice,
                     xtest = na.roughfix(datasets[[3]]),
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     importance=T)
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf1[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

# mean of imputed medians with feature eng data: 0.1620963
mean(metrics)

# importance

varImpPlot(rf1)


### missing as factor level ###
model2data = data %>% 
  mutate(across(where(is.character), \(x) replace_na(x, "unknown"))) %>% 
  mutate(across(where(is.numeric), \(x) replace_na(x, -99)))

model2data = model2data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  
  datasets = fold_ttsplit(model2data, "SalePrice", f)
  print('datasets created')
  
  rf2 = randomForest(datasets[[1]],
                     datasets[[2]]$SalePrice,
                     xtest = datasets[[3]],
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     importance=T,
                     keep.forest = T)
  
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf2[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

metrics

# mean of missing as factor level with feature engineered data: 0.1629938
mean(metrics)

# importance plot
varImpPlot(rf2)

# top 12
# OverallQual, GarageArea, GarageCars, TotalBsmtSF, GrLivArea, Tot_qual_cond,
# Neighborhood, 1stFlrSF, ExterQual, BsmtFinSF1

varUsed(rf2) # columns 5 (Street), 9 (Utilities) and and 14 (Condition 2) were not used



######### train_cleaned_option2.csv ###############################

# read data
data = read_csv('train_cleaned_option2.csv') %>% 
  select(!c('...1', 'Id'))

# divide into 5 folds
fold_assn <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(data), replace=TRUE)
data = cbind(data, fold_assn)


### imputed medians ###
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  print(f)
  
  datasets = fold_ttsplit(model1data, "SalePrice", f)
  print('datasets created')
  
  rf1 = randomForest(na.roughfix(datasets[[1]]),
                     datasets[[2]]$SalePrice,
                     xtest = na.roughfix(datasets[[3]]),
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     importance=T)
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf1[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

rf1

# mean: 0.1475555
mean(metrics)

# importance

varImpPlot(rf1)


### missing as factor level ###
model2data = data %>% 
  mutate(across(where(is.character), \(x) replace_na(x, "unknown"))) %>% 
  mutate(across(where(is.numeric), \(x) replace_na(x, -99)))

model2data = model2data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  
  datasets = fold_ttsplit(model2data, "SalePrice", f)
  print('datasets created')
  
  rf2 = randomForest(datasets[[1]],
                     datasets[[2]]$SalePrice,
                     xtest = datasets[[3]],
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     importance=T,
                     keep.forest = T)
  
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf2[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

rf2

# mean: 0.1480007
mean(metrics)

# importance plot
varImpPlot(rf2)


######### imputed medians, most engineered features, other params experiment ###

# read data
data = read_csv('train_cleaned_option2.csv') %>% 
  select(!c('...1', 'Id'))

# divide into 5 folds
fold_assn <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(data), replace=TRUE)
data = cbind(data, fold_assn)


### imputed medians ###
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  print(f)
  
  datasets = fold_ttsplit(model1data, "SalePrice", f)
  print('datasets created')
  
  rf1 = randomForest(na.roughfix(datasets[[1]]),
                     datasets[[2]]$SalePrice,
                     xtest = na.roughfix(datasets[[3]]),
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     nodesize=9)
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf1[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

mean(metrics)

rf1

# mean replace=F: 0.147838
# importance=F: 0.1475617
# localImp=T:0.1475551
# corr.bias=T: 0.1475968
# 400 trees: 0.1476046
# 600 trees: 0.1476241

# mean nodesize=9: 0.1474749

######### imputed medians, tuned parameters, outdoor features ###

# read data
data = read_csv('train_cleaned_option3.csv') %>% 
  select(!c('...1', 'Id'))

# divide into 5 folds
fold_assn <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(data), replace=TRUE)
data = cbind(data, fold_assn)


### imputed medians ###
model1data = data %>% 
  mutate(across(where(is.character), factor)) # convert categoricals to factors

metrics = c()

for (f in c('fold1', 'fold2', 'fold3', 'fold4', 'fold5')){
  print(f)
  
  datasets = fold_ttsplit(model1data, "SalePrice", f)
  print('datasets created')
  
  rf1 = randomForest(na.roughfix(datasets[[1]]),
                     datasets[[2]]$SalePrice,
                     xtest = na.roughfix(datasets[[3]]),
                     ytest = datasets[[4]]$SalePrice,
                     ntree=500, 
                     nodesize=9)
  print('forest created')
  
  test_len = nrow(datasets[[4]])
  
  SSE = 0
  
  for (i in 1:test_len){
    ith_SE = (log(rf1[['test']]$predicted[i]) - log(datasets[[4]]$SalePrice[i]))^2
    SSE = SSE + ith_SE
  }
  print('error calculated')
  
  metrics = append(metrics, sqrt(SSE/test_len))
}

mean(metrics) # 0.1487668






