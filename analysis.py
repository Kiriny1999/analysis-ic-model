# 导入必要的库
import pandas as pd
from pandas.io.stata import StataReader
import glob
import os

# 获取data_raw/2025/self目录下所有的stata文件
stata_files = glob.glob("data_raw/2015/self/*.dta")

# 读取并合并所有stata文件
dfs = []
for file in stata_files:
    df = pd.read_stata(file)
    dfs.append(df)
    
# 合并所有数据框
merged_data = pd.concat(dfs, axis=0, ignore_index=True)

