
import pandas as pd
pd.set_option('future.no_silent_downcasting', True)

import numpy as np

## code ordinal as integers where possible ##

# read data
data = pd.read_csv('train.csv')

# code ordinals - likert-style
data_eng = data.replace(['Po', 'Fa', 'TA', 'Gd', 'Ex'], [-2, -1, 0, 1, 2])

# code ordinals - individual columns
data_eng = data_eng.replace({'LotShape': {'Reg': 0,
                                      'IR1': 1,
                                      'IR2': 2,
                                      'IR3': 3},
                             'LandSlope': {'Gtl': 1, # LandSlope includes no missings
                                       'Mod': 2,
                                       'Sev': 3},
                             'Condition1': {'PosA': 2,
                                        'PosN': 1,
                                        'Norm': 0,
                                        'RRNe': -1,
                                        'RRNn': -1,
                                        'RRAe': -2,
                                        'RRAn': -2,
                                        'Artery': -2,
                                        'Feedr': -2},
                             'Condition2': {'PosA': 2,
                                        'PosN': 1,
                                        'Norm': 0,
                                        'RRNe': -1,
                                        'RRNn': -1,
                                        'RRAe': -2,
                                        'RRAn': -2,
                                        'Artery': -2,
                                        'Feedr': -2},
                             'HouseStyle': {'1Story': 1,
                                        '1.5Unf': 2,
                                        '1.5Fin': 3,
                                        '2Story': 4,
                                        '2.5Unf': 5,
                                        '2.5Fin': 6,
                                        'SFoyer': np.nan,
                                        'SLevel': np.nan},
                             'BsmtExposure': {'No': 0,
                                          'Mn': 1,
                                          'Av': 2,
                                          'Gd': 3},
                             'BsmtFinType1': {'Unf': 0,
                                          'LwQ': 1,
                                          'Rec': 2,
                                          'BLQ': 3,
                                          'ALQ': 4,
                                          'GLQ': 5},
                             'BsmtFinType2': {'Unf': 0,
                                          'LwQ': 1,
                                          'Rec': 2,
                                          'BLQ': 3,
                                          'ALQ': 4,
                                          'GLQ': 5},
                             'CentralAir': {'N': 0,
                                        'Y': 1},
                             'Electrical': {'SBrkr': 1,
                                        'FuseA': 0,
                                        'FuseF': -1,
                                        'FuseP': -2,
                                        'Mix': -1}, # setting Mix to same as Fair
                             'Functional': {'Typ': 0,
                                        'Min1': -1,
                                        'Min2': -2,
                                        'Mod': -3,
                                        'Maj1': -4,
                                        'Maj2': -5,
                                        'Sev': -6,
                                        'Sal': -7},
                             'GarageFinish': {'Unf': 1,
                                          'RFn': 2,
                                          'Fin': 3}
                             })

# where missing data has a meaning, assign a value
data_eng = data_eng.fillna({'Alley': 'None',
                 'BsmtQual': -1, # same as "fair" height
                 'BsmtCond': 0, # same as "typical" condition
                 'BsmtExposure': -1, # less than "no exposure"
                 'BsmtFinType1': 0, # same as "unfinished",
                 'BsmtFinType2': 0,
                 'FireplaceQu': -2, # same as poor quality
                 'GarageType': 'None',
                 'GarageFinish': 0, # less than 'unfinished'
                 'GarageQual': -2, # same as poor quality
                 'GarageCond': -2, # same as poor condition
                 'PoolQC': -1, # same as 'fair'
                 'Fence': 'None',
                 'MiscFeature': 'None',
                 'MiscVal': 0
                 })

# add quality sum which will be somewhat continuous
data_eng['Tot_qual_cond'] = pd.to_numeric(data_eng['ExterQual'] +
                                           data_eng['ExterCond'] +
                                           data_eng['BsmtCond'] +
                                           data_eng['HeatingQC'] +
                                           data_eng['KitchenQual'] +
                                           data_eng['FireplaceQu'] +
                                           data_eng['GarageQual'] +
                                           data_eng['GarageCond'] +
                                           data_eng['PoolQC'])

# insert neighborhood center lat and long in decimal degrees
hoods = pd.read_csv('neighborhood_coords.csv')
data_eng = data_eng.merge(hoods, how='left', left_on='Neighborhood', right_on='neighborhood')
data_eng = data_eng.drop(columns='neighborhood')

# write
data_eng.to_csv('train_cleaned_option1.csv')

# cast dataframe to numeric, drop columns that were not coded as ordinals and now are all NaN, drop Id
data_eng = data_eng.apply(pd.to_numeric, errors='coerce').dropna(axis='columns', how='all')

# write all numeric dataframe
data_eng.to_csv('train_num.csv')