
import pandas as pd
pd.set_option('future.no_silent_downcasting', True)

import numpy as np

# set up data
data = pd.read_csv('train.csv')

# code ordinals
data_eng = data.replace({'Alley': {'Grvl': 1, # Alley includes NaN if not gravel or paved
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
                         'YearBuilt': {}



                        })

# code ordinals requiring conditions
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask(data_eng['YearBuilt'] < 1900, 1899) # earliest is 1972
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask((data_eng['YearBuilt'] >= 1900) & (data_eng['YearBuilt'] < 1925), 1924)
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask((data_eng['YearBuilt'] >= 1925) & (data_eng['YearBuilt'] < 1950), 1949)
data_eng['YearBuilt'] = data_eng['YearBuilt'].mask((data_eng['YearBuilt'] >= 1950) & (data_eng['YearBuilt'] < 1975), 1974)