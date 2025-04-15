import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
import numpy as np

# 读取数据
df = pd.read_csv('data_export/data_ic/covered_individuals.csv')

# 数据预处理
# 选择用于聚类的特征
features = ['final_physical_score', 'cognitive_level', 'final_psychological_score', 
           'final_sensory_score', 'final_vitality_score']
X = df[features]

# 数据标准化
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 使用肘部法则确定最佳聚类数
inertias = []
K = range(1, 11)
for k in K:
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_scaled)
    inertias.append(kmeans.inertia_)

# 执行K-means聚类
optimal_k = 3  # 根据肘部法则图形选择最佳k值
kmeans = KMeans(n_clusters=optimal_k, random_state=42)
df['Cluster'] = kmeans.fit_predict(X_scaled)

# 分析每个聚类的特征
cluster_stats = df.groupby('Cluster').mean()



