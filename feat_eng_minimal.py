import pandas as pd

# read data
data = pd.read_csv('train.csv')

data_eng = data

# insert neighborhood center lat and long in decimal degrees
hoods = pd.read_csv('neighborhood_coords.csv')
data_eng = data_eng.merge(hoods, how='left', left_on='Neighborhood', right_on='neighborhood')
data_eng = data_eng.drop(columns='neighborhood')

# write
data_eng.to_csv('train_cleaned_minimal.csv')