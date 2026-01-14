---
name: statsmodels
description: Use when "statsmodels", "OLS regression", "statistical inference", "p-values", or asking about "linear regression", "logistic regression", "time series", "ARIMA", "hypothesis testing", "confidence intervals", "econometrics"
version: 1.0.0
---

<!-- Adapted from: claude-scientific-skills/scientific-skills/statsmodels -->

# Statsmodels Statistical Modeling

Python library for statistical modeling, estimation, and inference.

## When to Use

- Need regression with detailed diagnostics
- Statistical inference with p-values and confidence intervals
- Time series analysis (ARIMA, SARIMAX)
- Hypothesis testing
- Econometric analysis
- Publication-ready statistical tables

## Quick Start

```bash
pip install statsmodels
```

### Linear Regression (OLS)

```python
import statsmodels.api as sm

# ALWAYS add constant for intercept
X = sm.add_constant(X_data)

# Fit model
model = sm.OLS(y, X)
results = model.fit()

# View results
print(results.summary())

# Key outputs
print(f"R-squared: {results.rsquared:.4f}")
print(f"Coefficients:\n{results.params}")
print(f"P-values:\n{results.pvalues}")
```

## Common Models

### Logistic Regression

```python
from statsmodels.discrete.discrete_model import Logit

X = sm.add_constant(X_data)
model = Logit(y, X)
results = model.fit()

# Odds ratios
odds_ratios = np.exp(results.params)
```

### Generalized Linear Models

```python
import statsmodels.api as sm

# Poisson regression (count data)
model = sm.GLM(y, X, family=sm.families.Poisson())
results = model.fit()

# Gamma regression
model = sm.GLM(y, X, family=sm.families.Gamma())
```

### Time Series

```python
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tsa.statespace.sarimax import SARIMAX

# ARIMA
model = ARIMA(y, order=(1, 1, 1))
results = model.fit()
forecast = results.forecast(steps=10)

# SARIMAX (seasonal)
model = SARIMAX(y, order=(1, 1, 1), seasonal_order=(1, 1, 1, 12))
results = model.fit()
```

## Diagnostics

### Regression Diagnostics

```python
from statsmodels.stats.diagnostic import het_breuschpagan
from statsmodels.stats.stattools import durbin_watson

# Heteroskedasticity test
bp_test = het_breuschpagan(results.resid, X)
print(f"Breusch-Pagan p-value: {bp_test[1]:.4f}")

# Autocorrelation
dw = durbin_watson(results.resid)
print(f"Durbin-Watson: {dw:.4f}")

# Residual plot
import matplotlib.pyplot as plt
plt.scatter(results.fittedvalues, results.resid)
plt.axhline(y=0, color='r', linestyle='--')
plt.xlabel('Fitted values')
plt.ylabel('Residuals')
```

### Model Comparison

```python
# AIC/BIC
print(f"AIC: {results.aic:.2f}")
print(f"BIC: {results.bic:.2f}")

# Likelihood ratio test
from statsmodels.stats.diagnostic import compare_lr_test
lr_stat, p_value, df = compare_lr_test(results_full, results_reduced)
```

## Predictions

```python
# Point predictions
y_pred = results.predict(X_new)

# With confidence intervals
predictions = results.get_prediction(X_new)
pred_summary = predictions.summary_frame()
print(pred_summary)  # includes mean, CI, prediction intervals
```

## Formula Interface

```python
import statsmodels.formula.api as smf

# R-style formulas
model = smf.ols('y ~ x1 + x2 + x1:x2', data=df)
results = model.fit()

# Categorical variables automatic
model = smf.ols('y ~ x1 + C(category)', data=df)
```

## Statistical Tests

```python
from scipy import stats
from statsmodels.stats.weightstats import ttest_ind
from statsmodels.stats.anova import anova_lm

# t-test
t_stat, p_value, df = ttest_ind(group1, group2)

# ANOVA
model = smf.ols('value ~ C(group)', data=df).fit()
anova_table = anova_lm(model, typ=2)
```

## Best Practices

1. **Always add constant** for intercept (`sm.add_constant()`)
2. **Check diagnostics** before interpreting results
3. **Use formula API** for cleaner code with DataFrames
4. **Report confidence intervals** not just p-values
5. **Check assumptions** (normality, homoskedasticity)

## vs Alternatives

| Tool | Best For |
|------|----------|
| **Statsmodels** | Inference, diagnostics, econometrics |
| Scikit-learn | Prediction, ML pipelines |
| SciPy | Basic statistical tests |

## Resources

- Docs: <https://www.statsmodels.org/>
- Examples: <https://www.statsmodels.org/stable/examples/>
