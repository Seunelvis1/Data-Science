# 🔬 Breast Cancer Diagnosis — Classification with SVM + PCA

> A supervised machine learning classification project that diagnoses breast tumours as **Malignant** or **Benign** using 30 cellular features — combining PCA dimensionality reduction, Support Vector Machine classification, and StratifiedKFold cross-validation, optimised specifically for **Recall** to minimise missed cancer diagnoses.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.x-orange?logo=scikit-learn)](https://scikit-learn.org/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle%20%2F%20UCI-20BEFF?logo=kaggle)](https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data)
[![ML Type](https://img.shields.io/badge/ML%20Type-Classification-red)]()
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen)]()

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [What Makes This Project Different](#-what-makes-this-project-different)
- [Dataset](#-dataset)
  - [Source](#source)
  - [Features](#features)
  - [Class Distribution](#class-distribution)
- [Project Workflow](#-project-workflow)
- [Setup & Installation](#-setup--installation)
  - [Prerequisites](#prerequisites)
  - [Install Dependencies](#install-dependencies)
- [Exploratory Data Analysis](#-exploratory-data-analysis)
  - [Key Insights](#key-insights)
- [Data Preprocessing](#-data-preprocessing)
  - [Target Encoding](#target-encoding)
  - [Train/Test Split](#traintest-split)
  - [Why Stratified Split](#why-stratified-split)
- [Baseline Model](#-baseline-model)
- [Model Optimisation](#-model-optimisation)
  - [Pipeline Architecture](#pipeline-architecture)
  - [Why PCA](#why-pca)
  - [Why SVM with RBF Kernel](#why-svm-with-rbf-kernel)
  - [Hyperparameter Grid](#hyperparameter-grid)
  - [Why Recall as the Scoring Metric](#why-recall-as-the-scoring-metric)
- [Results](#-results)
  - [Best Hyperparameters](#best-hyperparameters)
  - [Training Performance](#training-performance)
  - [Test Performance](#test-performance)
  - [Baseline vs Final Model](#baseline-vs-final-model)
  - [Confusion Matrix](#confusion-matrix)
- [Predictive System](#-predictive-system)
- [Future Improvements](#-future-improvements)
- [Project Structure](#-project-structure)
- [Author](#-author)

---

## 📌 Project Overview

This project builds a **binary classification pipeline** to assist in the early diagnosis of breast cancer. Using digitised measurements from fine needle aspirate (FNA) images of breast masses, the model classifies each tumour as either **Malignant (M)** or **Benign (B)** — a decision with direct, life-critical consequences.

The pipeline introduces two concepts not seen in the regression projects:

1. **PCA (Principal Component Analysis)** — reduces 30 highly correlated features down to 10 principal components, removing noise and multicollinearity while retaining 95%+ of variance
2. **SVM (Support Vector Machine)** — a powerful classifier that finds the optimal decision boundary between classes

```
EDA → Encode Target → Stratified Split → Baseline (Logistic Regression) →
Pipeline (Scaler + PCA + SVC) → GridSearchCV (Recall-optimised) →
Final Evaluation → Confusion Matrix → Predictive System
```

---

## 🆕 What Makes This Project Different

This is the first **classification** project in this portfolio — a fundamental shift from both the regression and clustering work:

| Dimension | Regression | Clustering | Classification (This Project) |
|---|---|---|---|
| **Goal** | Predict a continuous number | Find hidden groups | Predict a category / class |
| **Target** | e.g. house price, insurance charges | None (unsupervised) | Malignant or Benign (binary) |
| **Evaluation** | RMSE, MAE, R² | Silhouette Score, WCSS | Accuracy, Precision, Recall, F1 |
| **Primary metric** | RMSE | Silhouette | **Recall** (domain-driven) |
| **New technique** | Log transform | Elbow method | PCA + SVM + Stratified CV |

---

## 📂 Dataset

### Source

| Detail | Value |
|---|---|
| **Name** | Breast Cancer Wisconsin (Diagnostic) Data Set |
| **Source** | [Kaggle / UCI ML Repository](https://www.kaggle.com/datasets/uciml/breast-cancer-wisconsin-data) |
| **File** | `breast_cancer_dataset.csv` |
| **Rows** | 569 patients |
| **Columns** | 32 (31 used — `id` dropped, `diagnosis` is the target) |

### Features

The dataset contains 30 numerical features computed from digitised images of fine needle aspirate (FNA) of a breast mass. Each feature is computed in three versions:

| Suffix | Description |
|---|---|
| `_mean` | Mean value across all cells in the image |
| `_se` | Standard error — variability across cells |
| `_worst` | Mean of the three largest values in the image |

The 10 base measurements (×3 versions = 30 features):

| Feature | What It Measures |
|---|---|
| `radius` | Mean distance from the cell nucleus centre to its perimeter |
| `texture` | Standard deviation of grey-scale pixel values |
| `perimeter` | Size of the cell nucleus perimeter |
| `area` | Area of the cell nucleus |
| `smoothness` | Local variation in radius lengths |
| `compactness` | Perimeter² / area − 1.0 |
| `concavity` | Severity of concave portions of the cell contour |
| `concave points` | Number of concave portions of the contour |
| `symmetry` | Symmetry of the cell nucleus |
| `fractal dimension` | "Coastline approximation" — boundary complexity |

> `id` was dropped (not informative). `diagnosis` was encoded: **B → 0 (Benign), M → 1 (Malignant)**.

### Class Distribution

| Class | Label | Count | Percentage |
|---|---|---|---|
| 0 | Benign | 357 | 62.7% |
| 1 | Malignant | 212 | 37.3% |

> The dataset has a **moderate class imbalance** (roughly 63/37). This is addressed by using `stratify=y` in the train/test split and selecting **Recall** as the primary evaluation metric.

---

## 🔄 Project Workflow

```
┌─────────────┐    ┌─────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  1. Setup   │ →  │  2. Load    │ →  │  3. EDA          │ →  │  4. Preprocessing   │
│  Libraries  │    │  Data       │    │  & Visualisation │    │  Encode + Split      │
└─────────────┘    └─────────────┘    └──────────────────┘    └─────────────────────┘
                                                                         │
┌──────────────────────┐    ┌────────────────────────────┐    ┌──────────────────────┐
│  8. Evaluation       │ ←  │  7. Retrain Best Pipeline  │ ←  │  5–6. Baseline →     │
│  Confusion Matrix    │    │  (Scaler + PCA + SVC)      │    │  GridSearchCV (SVC)  │
└──────────────────────┘    └────────────────────────────┘    └──────────────────────┘
         │
         ▼
┌─────────────────────────┐
│  9. Predictive System   │
│  predict_cancer()       │
└─────────────────────────┘
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
| `matplotlib` / `seaborn` | Visualisation, confusion matrix heatmaps |
| `sklearn.pipeline.Pipeline` | Chain scaler → PCA → model in one object |
| `sklearn.decomposition.PCA` | Dimensionality reduction from 30 → 10 components |
| `sklearn.svm.SVC` | Support Vector Classifier with RBF kernel |
| `sklearn.linear_model.LogisticRegression` | Baseline model |
| `sklearn.model_selection.StratifiedKFold` | Class-balanced cross-validation |
| `sklearn.model_selection.GridSearchCV` | Exhaustive hyperparameter search |
| `sklearn.metrics` | Accuracy, classification report, confusion matrix |

---

## 🔍 Exploratory Data Analysis

EDA covers the following steps:

- **Schema inspection** — 569 rows, 32 columns, 30 float features + 1 categorical target + id
- **Missing value analysis** — zero nulls across all 31 columns post-drop
- **Encoded missing value check** — `value_counts()` per column confirms no disguised nulls
- **Duplicate detection** — zero duplicates confirmed
- **Class distribution** — Benign 62.7%, Malignant 37.3% — moderate imbalance flagged
- **Grouped means** — `df.groupby("diagnosis").mean()` shows strong feature separation between classes
- **Distributions** — 7×5 histogram/KDE grid across all 31 features
- **Outlier analysis** — 7×5 boxplot grid across all features
- **Correlation heatmap** — 30×30 coolwarm heatmap revealing extensive multicollinearity among `_mean`, `_se`, and `_worst` groups

### Key Insights

| Finding | Detail |
|---|---|
| **No missing values** | Fully clean dataset — no imputation required |
| **No duplicates** | All 569 rows are unique |
| **Moderate class imbalance** | 63% Benign / 37% Malignant — stratified split required |
| **Strong class separation** | Mean feature values differ substantially between Benign and Malignant cases |
| **Outliers are meaningful** | Extreme values in features like `area_worst` and `concavity_worst` tend to represent Malignant cases — not noise to be removed |
| **High multicollinearity** | Heatmap shows strong correlations within `_mean`, `_se`, and `_worst` groups — motivates PCA |
| **Recall prioritised** | False negatives (predicting Benign when actually Malignant) are medically dangerous — Recall is selected as the primary metric |

---

## 🛠️ Data Preprocessing

### Target Encoding

The categorical target was label-encoded before modelling:

```python
df["diagnosis"] = df["diagnosis"].map({"B": 0, "M": 1})
# B (Benign)    → 0
# M (Malignant) → 1
```

### Train/Test Split

An **80/20 stratified split** was applied:

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size    = 0.2,
    stratify     = y,        # preserves class ratio in both splits
    random_state = 42
)
# X_train: (455, 30)  |  X_test: (114, 30)
```

### Why Stratified Split

Without `stratify=y`, a random split could place a disproportionate number of Malignant cases in training or test — skewing both model learning and evaluation. Stratification ensures both sets maintain the original 63/37 Benign/Malignant ratio.

---

## 📏 Baseline Model

A plain **Logistic Regression** (no PCA, no tuning) was trained as a performance benchmark using the scaled training data:

```python
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled  = scaler.transform(X_test)

model = LogisticRegression()
model.fit(X_train_scaled, y_train)
```

| Split | Accuracy |
|---|---|
| Train | 98.68% |
| Test | **96.49%** |

A strong baseline — but optimising for accuracy alone is insufficient in a medical context. A model that misclassifies Malignant tumours as Benign (false negatives) is the critical failure mode to minimise.

---

## ⚡ Model Optimisation

### Pipeline Architecture

A three-step `Pipeline` was built to chain preprocessing and modelling into a single, leak-proof object:

```python
pipeline = Pipeline([
    ("scaler", StandardScaler()),      # Step 1: Scale features
    ("pca",    PCA()),                 # Step 2: Reduce dimensions
    ("model",  SVC(kernel="rbf"))      # Step 3: Classify
])
```

### Why PCA

With 30 features and extensive multicollinearity (confirmed in the heatmap), raw features contain redundant information. PCA transforms them into **uncorrelated principal components**, ordered by the variance they explain. Benefits:

- Removes multicollinearity that can destabilise SVM
- Reduces computational cost of kernel calculations
- Retains the most informative structure while discarding noise

`n_components` was included in the hyperparameter grid to let GridSearchCV determine the optimal number of components.

### Why SVM with RBF Kernel

Support Vector Machines find the **maximum-margin hyperplane** between classes. With an **RBF (Radial Basis Function) kernel**, SVM maps features into a higher-dimensional space where a linear boundary can separate non-linearly distributed classes. Medical imaging data rarely separates linearly — RBF handles this naturally.

Two key SVM hyperparameters:

| Parameter | Role |
|---|---|
| `C` | Regularisation — higher C = allows fewer misclassifications, tighter fit |
| `gamma` | Kernel bandwidth — controls how far the influence of a single training point reaches |

### Hyperparameter Grid

```python
param_grid = [{
    "pca__n_components": [10, 15, 20, 25, 30],
    "model__C":          [0.1, 1, 10, 100, 1000],
    "model__gamma":      [0.001, 0.01, 0.1, 1, "scale"]
}]
```

**125 combinations × 5 folds = 625 model fits total.**

### Why Recall as the Scoring Metric

```python
grid_search = GridSearchCV(
    estimator = pipeline,
    param_grid = param_grid,
    scoring   = "recall",     # ← Optimise for Recall, not Accuracy
    cv        = skf,
    n_jobs    = -1
)
```

In cancer diagnosis, the two types of error have **asymmetric consequences**:

| Error Type | Prediction | Reality | Consequence |
|---|---|---|---|
| False Negative | Benign | Malignant | ⚠️ **Cancer missed — patient untreated** |
| False Positive | Malignant | Benign | Further tests ordered — inconvenient but safe |

**Recall = True Positives / (True Positives + False Negatives)**

Maximising Recall directly minimises the number of missed cancer diagnoses — the medically critical outcome. Accuracy would not penalise false negatives sufficiently.

**Cross-validation strategy:** `StratifiedKFold(n_splits=5)` ensures each fold maintains the class ratio — vital when classes are imbalanced.

---

## 📊 Results

### Best Hyperparameters

```python
Pipeline(steps=[
    ("scaler", StandardScaler()),
    ("pca",    PCA(n_components=10)),       # 30 features → 10 components
    ("model",  SVC(kernel="rbf", C=10, gamma="scale"))
])
```

| Parameter | Best Value | Interpretation |
|---|---|---|
| `pca__n_components` | 10 | 10 principal components capture sufficient variance from 30 original features |
| `model__C` | 10 | Moderate regularisation — allows some training errors to improve generalisation |
| `model__gamma` | "scale" | Automatically scaled to 1 / (n_features × X.var()) — adaptive to data scale |

**Best CV Recall: 0.9647 (96.47%)**

### Training Performance

| Metric | Score |
|---|---|
| **Accuracy** | 98.9% |
| **Precision (Malignant)** | 1.00 |
| **Recall (Malignant)** | 0.97 |
| **F1-Score (Malignant)** | 0.99 |

### Test Performance

| Metric | Benign (0) | Malignant (1) | Overall |
|---|---|---|---|
| **Precision** | 0.96 | 0.97 | — |
| **Recall** | 0.99 | 0.93 | — |
| **F1-Score** | 0.97 | 0.95 | — |
| **Accuracy** | — | — | **96.49%** |

> **Test Recall for Malignant class: 0.93** — the model correctly identified 93% of all actual Malignant tumours in the held-out test set. Only 3 out of 42 Malignant cases were missed (false negatives).

### Baseline vs Final Model

| Model | Test Accuracy | Test Recall (Malignant) |
|---|---|---|
| Baseline (Logistic Regression) | 96.49% | — |
| Final (SVC + PCA, tuned for Recall) | **96.49%** | **0.93** |

> Both models achieve the same test accuracy. The advantage of the final model lies in its **principled optimisation for Recall**, the reduction of features from 30 to 10 via PCA, and its robustness confirmed through 5-fold stratified cross-validation — making it more reliable and deployable than the baseline.

### Confusion Matrix

```
                  Predicted Benign    Predicted Malignant
Actual Benign          71                    1
Actual Malignant        3                   39
```

- **71** Benign tumours correctly identified ✅
- **39** Malignant tumours correctly identified ✅
- **1** Benign incorrectly predicted as Malignant (false positive — patient receives further tests)
- **3** Malignant incorrectly predicted as Benign (false negatives — the critical error to minimise)

![Confusion Matrix](screenshots/confusion_matrix_test.png)

---

## 🧮 Predictive System

A reusable function accepts a patient's 30 feature measurements and returns a diagnosis:

```python
def predict_cancer(input_features):
    input_df = pd.DataFrame(
        [input_features],
        columns=X_train.columns
    )
    prediction = best_pipeline.predict(input_df)
    if prediction[0] == 1:
        print("Diagnosis - Malignant 🔴")
    else:
        print("Diagnosis - Benign 🟢")
```

**Example predictions from test set:**

```python
# Patient 120 — actual: Benign
predict_cancer(X_test.loc[120].tolist())
# → Diagnosis - Benign 🟢  ✅

# Patient 250 — actual: Malignant
predict_cancer(X_test.loc[250].tolist())
# → Diagnosis - Malignant 🔴  ✅

# New unseen patient
predict_cancer([16.02, 23.24, 102.7, 797.8, ...])
# → Diagnosis - Malignant 🔴
```

The function passes input through the **full pipeline** (StandardScaler → PCA → SVC) — ensuring new data receives the identical transformations applied during training.

---

## 🚀 Future Improvements

- **Class imbalance handling** — apply SMOTE (Synthetic Minority Oversampling Technique) or class_weight="balanced" to further boost Recall on the minority (Malignant) class
- **Probability calibration** — use `SVC(probability=True)` and `predict_proba()` to output a cancer probability score (e.g. 87% likelihood of Malignant) rather than a binary label
- **ROC-AUC curve** — plot ROC curve and compute AUC score to evaluate the model's discrimination ability across all decision thresholds
- **Feature importance** — since PCA reduces interpretability, explore SHAP or permutation importance on the original 30 features to understand which raw measurements drive predictions
- **Extended model comparison** — benchmark SVC against Random Forest, XGBoost, and a Neural Network classifier under the same Recall-optimised CV framework
- **Threshold tuning** — adjust the classification threshold (default 0.5) downward to further prioritise Recall at the cost of Precision, as is common in medical screening pipelines
- **Persist the model** — save `best_pipeline` using `joblib` for deployment in a clinical decision-support tool

---

## 📁 Project Structure

```
breast-cancer-diagnosis/
│
├── breast_cancer_diagnosis.ipynb     # Main notebook — full ML pipeline
├── breast_cancer_dataset.csv         # Dataset (download from Kaggle / UCI)
├── README.md                         # Project documentation
└── screenshots/
    ├── confusion_matrix_train.png    # Add after exporting from notebook
    └── confusion_matrix_test.png     # Add after exporting from notebook
```

---


**Michael Adeniran**
Data Analyst & Data Science Specialist | PL-300 Certified

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://linkedin.com)
[![Portfolio](https://img.shields.io/badge/Portfolio-View-black?logo=github)](https://github.com)

---

> *This project is part of a data science portfolio demonstrating supervised classification, dimensionality reduction with PCA, Support Vector Machines, domain-driven metric selection, and end-to-end pipeline design using Python and scikit-learn.*
