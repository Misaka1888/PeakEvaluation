import ast
import pandas as pd
import numpy as np
from xgboost import XGBRegressor
from sklearn.model_selection import KFold
from sklearn.metrics import mean_squared_error, r2_score, accuracy_score
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('TkAgg')

# 读取CSV文件
data = pd.read_csv('./metrics_ml/34_5447.csv')
data = data.rename(columns=lambda x: ast.literal_eval(x)+1)  # 修改列名从1开始，方便做结果分析

X = data.iloc[:, :-1]
y = data.iloc[:, -1]   # 最后一列真值

model = XGBRegressor(objective='reg:squarederror', n_estimators=600, max_depth=4, learning_rate=0.03,
                    subsample=0.5, colsample_bytree=0.7, gamma=1.4, min_child_weight=6, random_state=42)

# n_splits次交叉验证
kf = KFold(n_splits=5, shuffle=True)

r2_arr = []
i=0
y_test_all = []
y_pred_all = []
for train_index, test_index in kf.split(X):
    X_train, X_test = X.iloc[train_index], X.iloc[test_index]
    y_train, y_test = y.iloc[train_index], y.iloc[test_index]

    model.fit(X_train, y_train)  # 训练

    y_pred = model.predict(X_test)  # 预测

    y_test_all.extend(y_test)
    y_pred_all.extend(y_pred)

    i = i+1

    mse = mean_squared_error(y_test, y_pred)
    print(f'Mean Squared Error: {mse}')

    # 计算回归模型R2
    r2 = r2_score(y_test, y_pred)
    print(f'R^2 Score: {r2}')
    r2_arr.append(r2)

print(f'Average r2: {np.mean(r2_arr)}')

plt.figure(figsize=(8, 6))
plt.scatter(y_test_all, y_pred_all, c='red', alpha=0.8)
plt.plot([min(y_test_all), max(y_test_all)], [min(y_test_all), max(y_test_all)], 'b--', linewidth=2)
plt.title('Predicted vs True Values')
plt.xlabel('True Values')
plt.ylabel('Predicted Values')
plt.grid()
plt.show()

# 保存模型
# model.save_model('xgboost_model.json')
