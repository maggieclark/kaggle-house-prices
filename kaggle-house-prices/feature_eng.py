
import pandas as pd
pd.set_option('future.no_silent_downcasting', True)

import numpy as np

## code categorical as ordinal where possible ##

# read data
data = pd.read_csv('train.csv')

# code ordinals - likert-style
data_eng = data.replace(['Po', 'Fa', 'TA', 'Gd', 'Ex'], [-2, -1, 0, 1, 2])

# code ordinals - individual columns
data_eng = data_eng.replace({'Alley': {'Grvl': 1, # Alley includes NaN if not gravel or paved
                                   'Pave': 1},
                             'LotShape': {'Reg': 0,
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



# replace quality measures with quality sum which will be somewhat continuous
data_cont = data.replace(['Po', 'Fa', 'TA', 'Gd', 'Ex'], [-2, -1, 0, 1, 2])
data_cont['Tot_qual_cond'] = pd.to_numeric(data_cont['ExterQual'] +
                                           data_cont['ExterCond'] +
                                           data_cont['BsmtCond'] +
                                           data_cont['HeatingQC'] +
                                           data_cont['KitchenQual'] +
                                           data_cont['FireplaceQu'] +
                                           data_cont['GarageQual'] +
                                           data_cont['GarageCond'] +
                                           data_cont['PoolQC'])


# replace neighborhood name with neighborhood center lat and long in decimal degrees
hoods = pd.read_csv('neighborhood_coords.csv')


# cast dataframe to numeric, drop columns that were not coded as ordinals and now are all NaN, drop Id
data_num = data_eng.apply(pd.to_numeric, errors='coerce').dropna(axis='columns', how='all').drop(columns='Id')




# write
data_num.to_csv('train_num.csv')