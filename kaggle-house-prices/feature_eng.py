
import pandas as pd
pd.set_option('future.no_silent_downcasting', True)

import numpy as np

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

# code ordinals  - requiring conditions
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask(data_eng['YearBuilt'] < 1900, 1899) # earliest is 1972
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask((data_eng['YearBuilt'] >= 1900) & (data_eng['YearBuilt'] < 1925), 1924)
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask((data_eng['YearBuilt'] >= 1925) & (data_eng['YearBuilt'] < 1950), 1949)
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask((data_eng['YearBuilt'] >= 1950) & (data_eng['YearBuilt'] < 1975), 1974)

data_eng['YearRemodAdd'] = data_eng['YearRemodAdd'].mask(data_eng['YearBuilt'] < 1975, 1974)


# cast dataframe to numeric, drop columns that were not coded as ordinals and now are all NaN, drop Id
data_num = data_eng.apply(pd.to_numeric, errors='coerce').dropna(axis='columns', how='all').drop(columns='Id')

# write
data_num.to_csv('train_num.csv')