# 🏡 California House Price Prediction

> A supervised machine learning regression project to predict California median house values using the classic California Housing dataset — covering the full ML workflow from EDA through to a deployable predictive system.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.x-orange?logo=scikit-learn)](https://scikit-learn.org/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF?logo=kaggle)](https://www.kaggle.com/datasets/camnugent/california-housing-prices)
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
  - [Preprocessing Pipeline](#preprocessing-pipeline)
- [Modelling](#-modelling)
  - [Baseline Model](#baseline-model)
  - [Model Selection via Cross-Validation](#model-selection-via-cross-validation)
  - [Hyperparameter Tuning](#hyperparameter-tuning)
- [Results](#-results)
  - [Baseline vs Final Model](#baseline-vs-final-model)
  - [Best Hyperparameters](#best-hyperparameters)
- [Predictive System](#-predictive-system)
- [Future Improvements](#-future-improvements)
- [Project Structure](#-project-structure)
- [Author](#-author)

---

## 📌 Project Overview

This project builds an end-to-end machine learning regression pipeline to predict **median house values** across California census blocks. Using the widely referenced California Housing Prices dataset, the project demonstrates a structured approach to applied data science:

```
EDA → Preprocessing → Baseline Model → Model Selection (CV) → Tuning (GridSearchCV) → Final Evaluation → Inference
```

The final model — a tuned **HistGradientBoostingRegressor** — is wrapped in a reusable prediction function that accepts new house inputs and returns a price estimate in USD.

---

## 📂 Dataset

### Source

| Detail | Value |
|---|---|
| **Name** | California Housing Prices |
| **Source** | [Kaggle](https://www.kaggle.com/datasets/camnugent/california-housing-prices) |
| **File** | `housing.csv` |
| **Rows** | ~20,640 |
| **Target Column** | `median_house_value` |

### Features

| # | Feature | Description |
|---|---|---|
| 1 | `longitude` | How far west a house is — higher value = farther west |
| 2 | `latitude` | How far north a house is — higher value = farther north |
| 3 | `housing_median_age` | Median age of houses in a block — lower = newer |
| 4 | `total_rooms` | Total number of rooms within a block |
| 5 | `total_bedrooms` | Total number of bedrooms within a block ⚠️ *contains missing values* |
| 6 | `population` | Total number of people residing within a block |
| 7 | `households` | Total number of households within a block |
| 8 | `median_income` | Median income for households (in tens of thousands USD) |
| 9 | `ocean_proximity` | Location of house relative to the ocean — categorical |
| 🎯 | `median_house_value` | **Target** — median house value in USD |

---

## 🔄 Project Workflow

```
┌─────────────┐    ┌─────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  1. Setup   │ →  │  2. Load    │ →  │  3. EDA          │ →  │  4. Preprocessing   │
│  Libraries  │    │  Data       │    │  & Visualisation │    │  Pipeline           │
└─────────────┘    └─────────────┘    └──────────────────┘    └─────────────────────┘
                                                                         │
┌─────────────────────┐    ┌───────────────────┐    ┌──────────────────────────────┐
│  9. Final           │ ←  │  8. Retrain with  │ ←  │  5–7. Baseline → CV          │
│  Evaluation         │    │  Best Params      │    │  Selection → Tuning          │
└─────────────────────┘    └───────────────────┘    └──────────────────────────────┘
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
pip install numpy pandas matplotlib seaborn scikit-learn
```

Or in a Jupyter/Colab environment:

```python
%pip install -q numpy pandas matplotlib seaborn scikit-learn
```

**Core libraries used:**

| Library | Purpose |
|---|---|
| `pandas` | Data loading and manipulation |
| `numpy` | Numerical computing |
| `matplotlib` / `seaborn` | Data visualisation |
| `scikit-learn` | Preprocessing, modelling, evaluation |

---

## 🔍 Exploratory Data Analysis

EDA covers the following investigative steps:

- **Schema inspection** — column types, shape, and basic info
- **Missing value analysis** — identifying null counts per column
- **Duplicate detection** — checking for redundant rows
- **Descriptive statistics** — mean, std, min/max, quartiles
- **Distribution plots** — histograms and KDE for all numeric features
- **Outlier analysis** — boxplots for all numeric features
- **Correlation heatmap** — identifying multicollinearity and feature-target relationships
- **Target distribution** — assessing skew and value caps on `median_house_value`
- **Categorical breakdown** — countplot for `ocean_proximity`

### Key Insights

| Finding | Detail |
|---|---|
| **Missing data** | Only `total_bedrooms` contains null values |
| **Target distribution** | Right-skewed; capped at $500,000 |
| **Strongest predictor** | `median_income` has the highest correlation with target |
| **Multicollinearity** | High correlation among `total_rooms`, `total_bedrooms`, `population`, `households` |
| **Feature types** | 8 numeric features + 1 categorical (`ocean_proximity`) |
| **Outliers** | Several features exhibit significant right skew and upper outliers |

---

## 🛠️ Data Preprocessing

The train/test split uses an **80/20 ratio** (`random_state=42`) to ensure reproducibility.

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
```

### Preprocessing Pipeline

A `ColumnTransformer` handles the two feature types separately, embedded inside a `Pipeline` to **prevent data leakage**:

```
Numerical features
  └── SimpleImputer (strategy="median")
  └── StandardScaler

Categorical features
  └── SimpleImputer (strategy="most_frequent")
  └── OneHotEncoder (handle_unknown="ignore")
```

**Why pipelines?** Fitting transformers only on training data (not the test set) ensures the preprocessing reflects real-world inference conditions and prevents information leakage from test data into the model.

---

## 🤖 Modelling

### Baseline Model

A plain `LinearRegression` model (no cross-validation, no tuning) was trained as a performance benchmark.

```python
baseline_pipe = Pipeline([
    ("preprocess", preprocess),
    ("model", LinearRegression())
])
```

### Model Selection via Cross-Validation

Five candidate models were evaluated using **5-fold cross-validation** on the training set, scored on RMSE, MAE, and R²:

| Model | CV RMSE | CV MAE | CV R² |
|---|---|---|---|
| `HistGradientBoostingRegressor` | **Best** ✅ | — | — |
| `RandomForestRegressor` | 2nd | — | — |
| `Ridge` | — | — | — |
| `Lasso` | — | — | — |
| `LinearRegression` | Highest | — | — |

> **Winner: HistGradientBoostingRegressor** — selected as the best model based on lowest cross-validation RMSE.

### Hyperparameter Tuning

`GridSearchCV` (5-fold CV, `scoring="neg_root_mean_squared_error"`) was used to search over the following parameter grid:

| Parameter | Values Searched |
|---|---|
| `learning_rate` | 0.03, 0.05, 0.1 |
| `max_depth` | None, 3, 6 |
| `max_leaf_nodes` | 15, 31, 63 |
| `min_samples_leaf` | 20, 50, 100 |
| `l2_regularization` | 0.0, 0.1, 1.0 |

---

## 📊 Results

### Baseline vs Final Model

| Metric | Baseline (Linear Regression) | Final (Tuned HistGB) |
|---|---|---|
| **Train RMSE** | Higher | Lower ✅ |
| **Test RMSE** | Higher | Lower ✅ |
| **Test MAE** | Higher | Lower ✅ |
| **Test R²** | Lower | Higher ✅ |

### Best Hyperparameters

```python
HistGradientBoostingRegressor(
    l2_regularization = 0.1,
    learning_rate     = 0.1,
    max_depth         = None,
    max_leaf_nodes    = 63,
    min_samples_leaf  = 20,
    random_state      = 42
)
```

**Post-tuning diagnostics include:**
- Residuals vs Predictions scatter plot — checks for heteroscedasticity
- Residual distribution histogram — assesses normality of errors

---

## 🧮 Predictive System

The final trained pipeline is wrapped in a clean inference function for single-observation prediction:

```python
def predict_house_price(
    model,
    longitude: float,
    latitude: float,
    housing_median_age: float,
    total_rooms: float,
    total_bedrooms: float,   # accepts np.nan — pipeline will impute
    population: float,
    households: float,
    median_income: float,
    ocean_proximity: str     # e.g. "NEAR BAY", "INLAND", "<1H OCEAN"
) -> float:
    ...
```

**Example inference:**

```python
predict_house_price(
    model            = hgb_best,
    longitude        = -122.230,
    latitude         = 37.880,
    housing_median_age = 41,
    total_rooms      = 880,
    total_bedrooms   = 129,
    population       = 322,
    households       = 126,
    median_income    = 8.3252,
    ocean_proximity  = "NEAR BAY"
)
```

---

## 🚀 Future Improvements

The following enhancements could further boost model performance:

- **Feature engineering** — create ratio features:
  - `rooms_per_household`
  - `bedrooms_per_room`
  - `population_per_household`
- **Target transformation** — apply log transformation to `median_house_value` to reduce skew and improve linearity
- **Extended tuning** — explore `max_iter` and `max_bins` parameters for HistGradientBoosting
- **Advanced boosting** — benchmark against XGBoost or LightGBM
- **Error analysis** — segment residuals by location and price range to identify where the model underperforms
- **Spatial validation** — use geographically grouped cross-validation folds to better reflect location-based data structure

---

## 📁 Project Structure

```
california-house-price-prediction/
│
├── 15_4_house_price_prediction.ipynb   # Main notebook — full ML pipeline
├── housing.csv                          # Dataset (download from Kaggle)
└── README.md                            # Project documentation
```

---


> *This project is part of a data science portfolio demonstrating applied machine learning, feature engineering, and end-to-end pipeline design using Python and scikit-learn.*
