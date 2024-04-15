# train test split
ttsplit = function(prepped_data, outcome_column){
  
  sample <- sample(c('fold1', 'fold2', 'fold3', 'fold4', 'fold5'), nrow(prepped_data), replace=TRUE, prob=c(0.7,0.3))
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

# train test split for use within a cross val loop
fold_ttsplit = function(prepped_data, outcome_column, fold){
  
  train  <- prepped_data %>% filter(fold_assn == fold) %>% select(!fold_assn)
  print("train created")
  test   <- prepped_data %>% filter(fold_assn != fold) %>% select(!fold_assn)
  print('test created')
  
  Xtrain = train %>% 
    select(!{{outcome_column}})
  
  ytrain = train %>% 
    select({{outcome_column}})
  
  Xtest = test %>% 
    select(!{{outcome_column}})
  
  ytest = test %>% 
    select({{outcome_column}})
  
  return(list(Xtrain, ytrain, Xtest, ytest))
}
