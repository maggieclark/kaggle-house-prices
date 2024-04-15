import pandas as pd
import numpy as np
from sklearn.neural_network import MLPRegressor
from sklearn.model_selection import train_test_split
import missingno as msno

# set up data
data = pd.read_csv('train_cleaned_option2.csv')

# cast dataframe to numeric, drop columns that are now nan and Id
data_numeric = data.apply(pd.to_numeric, errors='coerce').dropna(axis='columns', how='all').drop(columns=['Id', 'Unnamed: 0'])

# missing values
msno.heatmap(data_numeric)

# separate outcome
X = data_numeric.drop(columns='SalePrice')
y = data_numeric['SalePrice']

# nn
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=117)

# impute missing values
X_train = X_train.fillna(X_train.mean())
X_test = X_test.fillna(X_test.mean())

regr = MLPRegressor(hidden_layer_sizes=(8,8,8),
                    random_state=117,
                    max_iter=10000,
                    early_stopping=True,
                    validation_fraction = 0.05)
regr.fit(X_train, y_train)
y_hat = regr.predict(X_test)
error = np.sqrt(np.mean((np.log(y_hat)-np.log(y_test))**2))
error