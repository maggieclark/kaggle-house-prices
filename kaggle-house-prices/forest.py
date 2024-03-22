
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import KFold
import xgboost as xgb

# set up data
data = pd.read_csv('train_num.csv')
# numeric = data.select_dtypes(include=np.number).drop(columns='Id')
X = data.drop(columns='SalePrice')
y = data['SalePrice']
kf = KFold(n_splits=5, shuffle=True, random_state=117)
fold1, fold2, fold3, fold4, fold5 = kf.split(X)
folds = [fold1, fold2, fold3, fold4, fold5]

# set up model
# regr = RandomForestRegressor(random_state=117)
regr = xgb.XGBRegressor(tree_method="hist", device="cpu")
error = []

# cross val loop
for i in range(5):

    fold = folds[i]

    # set up datasets for this loop
    X_train = X.iloc[fold[0]]
    y_train = y.iloc[fold[0]]
    X_val = X.iloc[fold[1]]
    y_val = y.iloc[fold[1]]

    # fit model
    regr.fit(X_train, y_train)

    # evaluate
    y_hat = regr.predict(X_val)
    error.append(np.sqrt(np.mean((np.log(y_hat)-np.log(y_val))**2)))