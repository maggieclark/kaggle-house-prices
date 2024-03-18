
import pandas as pd

# set up data
data = pd.read_csv('train.csv')

data.replace({'Alley': {'Grvl': 1, # Alley includes NaN if not gravel or paved
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

              })