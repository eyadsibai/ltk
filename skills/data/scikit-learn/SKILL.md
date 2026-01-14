---
name: scikit-learn
description: Use when "scikit-learn", "sklearn", "machine learning", "classification", "regression", "clustering", or asking about "train test split", "cross validation", "hyperparameter tuning", "ML pipeline", "random forest", "SVM", "preprocessing"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/scikit-learn -->

# Scikit-learn Machine Learning

Industry-standard Python library for classical machine learning.

## When to Use

- Classification or regression tasks
- Clustering or dimensionality reduction
- Preprocessing and feature engineering
- Model evaluation and cross-validation
- Hyperparameter tuning
- Building ML pipelines

## Quick Start

```bash
pip install scikit-learn
```

### Classification Example

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# Preprocess
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)

# Evaluate
y_pred = model.predict(X_test_scaled)
print(classification_report(y_test, y_pred))
```

## Common Algorithms

### Classification

```python
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
```

### Regression

```python
from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.svm import SVR
```

### Clustering

```python
from sklearn.cluster import KMeans, DBSCAN, AgglomerativeClustering
from sklearn.mixture import GaussianMixture
```

### Dimensionality Reduction

```python
from sklearn.decomposition import PCA, TruncatedSVD
from sklearn.manifold import TSNE
```

## Pipelines

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer

# Define feature types
numeric_features = ['age', 'income']
categorical_features = ['gender', 'occupation']

# Create preprocessing
numeric_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='median')),
    ('scaler', StandardScaler())
])

categorical_transformer = Pipeline([
    ('imputer', SimpleImputer(strategy='most_frequent')),
    ('onehot', OneHotEncoder(handle_unknown='ignore'))
])

preprocessor = ColumnTransformer([
    ('num', numeric_transformer, numeric_features),
    ('cat', categorical_transformer, categorical_features)
])

# Full pipeline
pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', RandomForestClassifier())
])

pipeline.fit(X_train, y_train)
```

## Cross-Validation

```python
from sklearn.model_selection import cross_val_score, GridSearchCV

# Simple CV
scores = cross_val_score(model, X, y, cv=5, scoring='accuracy')
print(f"Mean: {scores.mean():.3f} (+/- {scores.std()*2:.3f})")

# Grid search
param_grid = {
    'n_estimators': [50, 100, 200],
    'max_depth': [None, 10, 20]
}
grid_search = GridSearchCV(RandomForestClassifier(), param_grid, cv=5)
grid_search.fit(X_train, y_train)
print(f"Best params: {grid_search.best_params_}")
```

## Metrics

```python
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, roc_auc_score, mean_squared_error, r2_score
)

# Classification
print(f"Accuracy: {accuracy_score(y_test, y_pred):.3f}")
print(f"F1: {f1_score(y_test, y_pred, average='weighted'):.3f}")

# Regression
print(f"RMSE: {mean_squared_error(y_test, y_pred, squared=False):.3f}")
print(f"R2: {r2_score(y_test, y_pred):.3f}")
```

## Best Practices

1. **Always split data** before any preprocessing
2. **Use pipelines** to prevent data leakage
3. **Scale features** for distance-based algorithms
4. **Use stratified splits** for imbalanced classes
5. **Cross-validate** for reliable estimates

## Resources

- Docs: <https://scikit-learn.org/>
- User Guide: <https://scikit-learn.org/stable/user_guide.html>
- Examples: <https://scikit-learn.org/stable/auto_examples/>
