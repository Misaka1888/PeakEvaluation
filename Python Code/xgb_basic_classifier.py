import ast
import pandas as pd
import numpy as np
from xgboost import XGBClassifier
from sklearn.model_selection import KFold
from sklearn.metrics import mean_squared_error, r2_score, accuracy_score
import matplotlib.pyplot as plt

# 读取CSV文件
data = pd.read_csv('./metrics_ml/34_25000.csv')
data = data.rename(columns=lambda x: ast.literal_eval(x)+1)  # 修改列名从1开始，方便做结果分析

X = data.iloc[:, :-1]
y = data.iloc[:, -1]   # 最后一列真值

model = XGBClassifier(objective='binary:logistic', n_estimators=500, learning_rate=0.03, max_depth=7,
                    subsample=0.9, colsample_bytree=0.7, gamma=1.2, min_child_weight=2.5, random_state=100)

# n_splits次交叉验证
kf = KFold(n_splits=5, shuffle=True)

acc = []
i=0

for train_index, test_index in kf.split(X):
    X_train, X_test = X.iloc[train_index], X.iloc[test_index]
    y_train, y_test = y.iloc[train_index], y.iloc[test_index]

    model.fit(X_train, y_train)  # 训练

    y_pred = model.predict(X_test)  # 预测

    # 计算分类模型acc
    accuracy = accuracy_score(y_test, y_pred)
    acc.append(accuracy)
    i = i+1
    print(f'{i} Accuracy: {accuracy}')

print(f'Average acc: {np.mean(acc)}')

# 保存模型
# model.save_model('xgboost_model.json')
