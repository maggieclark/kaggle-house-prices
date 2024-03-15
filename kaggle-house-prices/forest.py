
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import KFold

# set up data
data = pd.read_csv('train.csv')
X = data.drop(columns='SalePrice')
y = data['SalePrice']
kf = KFold(n_splits=5, shuffle=True, random_state=117)
fold1, fold2, fold3, fold4, fold5 = kf.split(X)
folds = [fold1, fold2, fold3, fold4, fold5]

# set up model
regr = RandomForestRegressor(max_depth=2, random_state=117)
error = []

# cross val loop
for i in range(1):

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
    error[i] = np.sqrt(np.mean((np.log(y_hat)-np.log(y_val))**2))
