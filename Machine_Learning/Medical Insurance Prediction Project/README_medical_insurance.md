# 🏥 Medical Insurance Cost Prediction

> A supervised machine learning regression project to predict individual medical insurance charges using demographic and lifestyle features — covering the full ML workflow from EDA through to a deployable predictive system, including target log-transformation for skewed cost data.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.x-orange?logo=scikit-learn)](https://scikit-learn.org/)
[![XGBoost](https://img.shields.io/badge/XGBoost-latest-red)](https://xgboost.readthedocs.io/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF?logo=kaggle)](https://www.kaggle.com/datasets/mirichoi0218/insurance/data)
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen)]()

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [Dataset](#-dataset)
  - [Source](#source)
  - [Features](#features)
- [Project Workflow](#-project-workflow)
- [Setup & Installation](#-setup--installation)
  - [Prerequisites](#prerequisites)
  - [Install Dependencies](#install-dependencies)
- [Exploratory Data Analysis](#-exploratory-data-analysis)
  - [Key Insights](#key-insights)
- [Data Preprocessing](#-data-preprocessing)
  - [Train/Test Split](#traintest-split)
  - [Preprocessing Pipeline](#preprocessing-pipeline)
- [Modelling](#-modelling)
  - [Baseline Model](#baseline-model)
  - [Model Selection via Cross-Validation](#model-selection-via-cross-validation)
  - [Hyperparameter Tuning](#hyperparameter-tuning)
- [Log Transformation on Target](#-log-transformation-on-target)
- [Results](#-results)
  - [Baseline vs Final Model](#baseline-vs-final-model)
  - [Best Hyperparameters](#best-hyperparameters)
- [Predictive System](#-predictive-system)
- [Future Improvements](#-future-improvements)
- [Project Structure](#-project-structure)
- [Author](#-author)

---

## 📌 Project Overview

This project builds an end-to-end machine learning regression pipeline to predict **individual medical insurance charges** based on personal and lifestyle attributes. The pipeline follows a structured data science approach and introduces a **log transformation on the target variable** to handle the characteristic right-skew of cost data:

```
EDA → Preprocessing → Baseline (Linear Regression) → Model Selection (CV) →
Tuning (GridSearchCV) → Log Transform (TransformedTargetRegressor) →
Final Evaluation → Inference
```

The final model — a tuned **RandomForestRegressor** with a log-transformed target — is wrapped in a reusable prediction function that accepts a new person's details and returns an estimated annual insurance cost in USD.

---

## 📂 Dataset

### Source

| Detail | Value |
|---|---|
| **Name** | Medical Cost Personal Datasets |
| **Source** | [Kaggle](https://www.kaggle.com/datasets/mirichoi0218/insurance/data) |
| **File** | `insurance.csv` |
| **Rows** | 1,338 (1,337 after duplicate removal) |
| **Target Column** | `charges` |

### Features

| # | Feature | Type | Description |
|---|---|---|---|
| 1 | `age` | Numerical (continuous) | Age of the individual (18–64) |
| 2 | `sex` | Categorical | Gender — male or female |
| 3 | `bmi` | Numerical (continuous) | Body Mass Index — measure of body fat based on height/weight (15.96–53.13) |
| 4 | `children` | Numerical (discrete) | Number of dependent children covered by the plan (0–5) |
| 5 | `smoker` | Categorical (binary) | Whether the individual smokes — yes or no |
| 6 | `region` | Categorical | US residential region — northeast, northwest, southeast, southwest |
| 🎯 | `charges` | **Target** | Annual medical insurance cost billed to the individual (USD) |

---

## 🔄 Project Workflow

```
┌─────────────┐    ┌─────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  1. Setup   │ →  │  2. Load    │ →  │  3. EDA          │ →  │  4. Preprocessing   │
│  Libraries  │    │  Data       │    │  & Visualisation │    │  Pipeline           │
└─────────────┘    └─────────────┘    └──────────────────┘    └─────────────────────┘
                                                                         │
┌──────────────────────┐    ┌───────────────────────┐    ┌──────────────────────────┐
│  9. Final            │ ←  │  8. Log Transform     │ ←  │  5–7. Baseline → CV      │
│  Evaluation          │    │  (TransformedTarget)  │    │  Selection → Tuning      │
└──────────────────────┘    └───────────────────────┘    └──────────────────────────┘
         │
         ▼
┌─────────────────────┐
│  10. Predictive     │
│  System / Inference │
└─────────────────────┘
```

---

## ⚙️ Setup & Installation

### Prerequisites

- Python 3.8 or higher
- pip

### Install Dependencies

```bash
pip install numpy pandas matplotlib seaborn scikit-learn xgboost
```

Or in a Jupyter/Colab environment:

```python
%pip install -q numpy pandas matplotlib seaborn scikit-learn xgboost
```

**Core libraries used:**

| Library | Purpose |
|---|---|
| `pandas` | Data loading and manipulation |
| `numpy` | Numerical computing |
| `matplotlib` / `seaborn` | Data visualisation |
| `scikit-learn` | Preprocessing, modelling, evaluation, pipelines |
| `xgboost` | Gradient boosting regression model |

---

## 🔍 Exploratory Data Analysis

EDA covers the following investigative steps:

- **Schema inspection** — column types, shape, and basic info
- **Missing value analysis** — confirmed zero nulls across all columns
- **Encoded missing value check** — `value_counts()` per column to catch disguised nulls (e.g. "Unknown", -1)
- **Duplicate detection** — 1 duplicate found and removed
- **Descriptive statistics** — mean, std, min/max, quartiles
- **Distribution plots** — histograms and KDE for all numeric features
- **Outlier analysis** — boxplots for all numeric features
- **Correlation heatmap** — feature-target relationships and multicollinearity check
- **Pairplot with hue="smoker"** — revealing separation between smoker and non-smoker charge distributions
- **Categorical breakdown** — value counts for sex, smoker, region

### Key Insights

| Finding | Detail |
|---|---|
| **No missing values** | Dataset is fully complete — no imputation required |
| **1 duplicate removed** | Dataset reduced from 1,338 to 1,337 rows |
| **Target is right-skewed** | `charges` has a long right tail with extreme high-cost cases |
| **Dominant predictor** | `smoker` status causes dramatic charge separation — the single strongest signal |
| **Moderate predictors** | `age` (r = 0.298) and `bmi` (r = 0.198) have moderate linear correlation with charges |
| **Weak predictor** | `children` (r = 0.067) has minimal linear correlation |
| **No multicollinearity** | Numerical features are not highly correlated with each other |
| **Outliers present** | High-cost outliers visible in charges and BMI, especially among smokers |

---

## 🛠️ Data Preprocessing

### Train/Test Split

An **80/20 ratio** (`random_state=42`) was applied before fitting any preprocessing step:

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
# X_train: (1069, 6)  |  X_test: (268, 6)
```

### Preprocessing Pipeline

A `ColumnTransformer` handles the two feature types separately, embedded inside a `Pipeline` to prevent data leakage:

```
Numerical features (age, bmi, children)
  └── StandardScaler

Categorical features (sex, smoker, region)
  └── OneHotEncoder (handle_unknown="ignore")
```

> **Why no imputer here?** Unlike many real-world datasets, this one contains zero missing values, so no imputation step is required. The pipeline architecture is retained so one can be added trivially if needed on future data.

---

## 🤖 Modelling

### Baseline Model

A plain `LinearRegression` (no cross-validation, no tuning) was trained as a performance benchmark:

```python
baseline_pipe = Pipeline([
    ("preprocess", preprocess),
    ("model", LinearRegression())
])
```

**Baseline test performance:** MAE $4,177 · RMSE $5,956 · R² 0.807

### Model Selection via Cross-Validation

Six models were evaluated using **5-fold cross-validation** on the training set, scored by MAE (primary metric), RMSE, and R²:

| Model | CV MAE | CV RMSE | CV R² | Result |
|---|---|---|---|---|
| `RandomForestRegressor` | **$2,743** | $4,894 | 0.821 | ✅ Winner |
| `XGBRegressor` | $3,105 | $5,376 | 0.785 | 2nd |
| `DecisionTreeRegressor` | $3,284 | $6,778 | 0.659 | 3rd |
| `LinearRegression` | $4,222 | $6,124 | 0.723 | 4th |
| `Lasso` | $4,222 | $6,123 | 0.723 | 5th |
| `Ridge` | $4,227 | $6,124 | 0.723 | 6th |

> **Why MAE as primary metric?** MAE is more robust to extreme outliers than RMSE. In medical insurance data — where a small number of very high-cost claims could dominate RMSE — MAE gives a more representative picture of typical prediction accuracy.

> **Winner: RandomForestRegressor** — selected based on lowest CV MAE. Tree-based models outperformed linear models because the insurance data contains strong **non-linear interactions** (e.g. smoker × BMI combinations) that linear models cannot capture natively.

### Hyperparameter Tuning

`GridSearchCV` (5-fold CV, `scoring="neg_mean_absolute_error"`) was used to search over the following parameter grid:

| Parameter | Values Searched |
|---|---|
| `n_estimators` | 200, 300, 600, 900 |
| `max_depth` | None, 8, 15, 25 |
| `min_samples_split` | 2, 5, 10 |
| `min_samples_leaf` | 1, 2, 4 |
| `max_features` | "sqrt", "log2", 0.6, 0.8 |
| `bootstrap` | True |

**576 combinations × 5 folds = 2,880 model fits total.**

---

## 📐 Log Transformation on Target

The target variable (`charges`) is **right-skewed** — a small number of extremely high-cost individuals pull the distribution far to the right. A log transformation compresses these extreme values and produces a more normally distributed target, which helps the model learn more stable patterns.

`TransformedTargetRegressor` from scikit-learn handles the transformation automatically:

```python
rf_best_log = TransformedTargetRegressor(
    regressor=Pipeline([
        ("preprocess", preprocess),
        ("model", RandomForestRegressor(...))
    ]),
    func=np.log1p,          # applied to y before training
    inverse_func=np.expm1   # reverses the log at prediction time
)
```

This ensures predictions are returned in the **original USD scale** — the log/inverse-log conversion is completely transparent to the user of the inference function.

**Impact of log transformation:**

| Model | Test MAE | Test R² |
|---|---|---|
| Tuned RF (no log) | $2,380 | 0.901 |
| Tuned RF (with log) | **$1,961** | **0.900** |

The log transformation improved test MAE by **$419 (17.6%)** with negligible impact on R².

---

## 📊 Results

### Baseline vs Final Model

| Metric | Baseline (Linear Regression) | Final (Tuned RF + Log Transform) |
|---|---|---|
| **Test MAE** | $4,177 | **$1,961** ✅ |
| **Test RMSE** | $5,956 | **$4,284** ✅ |
| **Test R²** | 0.807 | **0.900** ✅ |

The final model reduced test MAE by **53%** compared to the baseline.

**Overfitting check:**

| Split | MAE | R² |
|---|---|---|
| Train | $1,749 | 0.879 |
| Test | $1,961 | 0.900 |

The small gap between train and test performance confirms the model generalises well.

**Post-evaluation diagnostics include:**
- Residuals vs Predictions scatter plot — checks for heteroscedasticity
- Residual distribution histogram — assesses normality and directional bias

### Best Hyperparameters

```python
RandomForestRegressor(
    bootstrap         = True,
    max_depth         = 8,
    max_features      = 0.8,
    min_samples_leaf  = 4,
    min_samples_split = 2,
    n_estimators      = 300,
    random_state      = 42
)
```

---

## 🧮 Predictive System

The final trained pipeline is wrapped in a clean inference function for single-observation prediction:

```python
def predict_insurance_charges(
    model,
    age: float,
    sex: str,            # "male" or "female"
    bmi: float,
    children: int,       # 0–5
    smoker: str,         # "yes" or "no"
    region: str          # "northeast" | "northwest" | "southeast" | "southwest"
) -> float:
    ...
```

**Example inference:**

```python
predict_insurance_charges(
    model    = rf_best_log,
    age      = 35,
    sex      = "male",
    bmi      = 29.5,
    children = 2,
    smoker   = "no",
    region   = "southeast"
)
# → $6,108.63
```

The function wraps inputs into a pandas DataFrame, passes it through the full preprocessing + model pipeline, and returns the prediction in USD (the log-inverse transform is handled internally by `TransformedTargetRegressor`).

---

## 🚀 Future Improvements

The following enhancements could further improve model performance and utility:

- **Feature engineering** — create interaction terms that the model can exploit explicitly:
  - `smoker_bmi` = smoker × bmi (interaction known to drive extreme costs)
  - `age_group` = binned age category
  - `bmi_category` = underweight / normal / overweight / obese flag
- **XGBoost tuning** — XGBoost came 2nd in CV comparison; with dedicated hyperparameter tuning (learning_rate, max_depth, n_estimators, subsample) it may outperform Random Forest
- **SHAP values** — use SHAP to produce interpretable feature importance, showing which factors drove each individual prediction
- **Quantile regression** — instead of predicting a single value, predict confidence intervals (e.g. 10th–90th percentile of expected costs) for more actionable insurance quotes
- **Deployment** — wrap the inference function in a FastAPI endpoint or Streamlit app for real-world use

---

## 📁 Project Structure

```
medical-insurance-cost-prediction/
│
├── medical_insurance_cost_prediction.ipynb   # Main notebook — full ML pipeline
├── insurance.csv                              # Dataset (download from Kaggle)
└── README.md                                  # Project documentation
```

---

## 👤 Author

**Michael Adeniran**
Data Analyst & Data Science Specialist | PL-300 Certified

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://linkedin.com)
[![Portfolio](https://img.shields.io/badge/Portfolio-View-black?logo=github)](https://github.com)

---

> *This project is part of a data science portfolio demonstrating applied machine learning, feature engineering, target transformation techniques, and end-to-end pipeline design using Python and scikit-learn.*
