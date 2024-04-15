import pandas as pd
import numpy as np
from sklearn.neural_network import MLPRegressor
from sklearn.model_selection import train_test_split

# set up data
data = pd.read_csv('train_cleaned_option2.csv')

# cast dataframe to numeric, drop columns that are now nan and Id
data_numeric = data.apply(pd.to_numeric, errors='coerce').dropna(axis='columns', how='all').drop(columns=['Id', 'Unnamed: 0'])

# separate outcome
X = data_numeric.drop(columns='SalePrice')
y = data_numeric['SalePrice']

# nn
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=117)
regr = MLPRegressor(random_state=117, max_iter=500).fit(X_train, y_train)
regr.predict(X_test[:2])
regr.score(X_test, y_test)