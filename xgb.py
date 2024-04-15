
import pandas as pd
import numpy as np
from sklearn.model_selection import KFold
import xgboost as xgb

# set up data
data = pd.read_csv('train_cleaned_option2.csv')

# cast dataframe to numeric, drop columns that are now nan and Id
data_numeric = data.apply(pd.to_numeric, errors='coerce').dropna(axis='columns', how='all').drop(columns=['Id', 'Unnamed: 0'])

# cross val folds
X = data_numeric.drop(columns='SalePrice')
y = data_numeric['SalePrice']
kf = KFold(n_splits=5, shuffle=True, random_state=117)
fold1, fold2, fold3, fold4, fold5 = kf.split(X)
folds = [fold1, fold2, fold3, fold4, fold5]

# set up model
regr = xgb.XGBRegressor(tree_method="hist", device="cpu")
error = [0,0,0,0,0]

# cross val loop
for i in range(5):

    fold = folds[i][1]

    # set up datasets for this loop
    X_val = X.iloc[fold]
    y_val = y.iloc[fold]
    X_train = X.loc[~X.index.isin(fold)]
    y_train = y.iloc[~y.index.isin(fold)]


    # fit model
    regr.fit(X_train, y_train)

    # evaluate
    y_hat = regr.predict(X_val)
    error[i] = np.sqrt(np.mean((np.log(y_hat)-np.log(y_val))**2))

# mean: 0.1423583054092579
np.mean(error)

regr.score(X_train, y_train)
regr.score(X_val, y_val)