# 🛍️ Customer Segmentation — K-Means Clustering

> An unsupervised machine learning project that segments 200 mall customers into 5 distinct behavioural groups using K-Means clustering — covering the full workflow from EDA through elbow method, silhouette evaluation, cluster visualisation, business profiling, and a deployable segment assignment function.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.x-orange?logo=scikit-learn)](https://scikit-learn.org/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF?logo=kaggle)](https://www.kaggle.com/datasets/vjchoudhary7/customer-segmentation-tutorial-in-python/data)
[![Type](https://img.shields.io/badge/ML%20Type-Unsupervised-purple)]()
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen)]()

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [What Makes This Different](#-what-makes-this-different)
- [Dataset](#-dataset)
  - [Source](#source)
  - [Features](#features)
  - [Key Statistics](#key-statistics)
- [Project Workflow](#-project-workflow)
- [Setup & Installation](#-setup--installation)
  - [Prerequisites](#prerequisites)
  - [Install Dependencies](#install-dependencies)
- [Exploratory Data Analysis](#-exploratory-data-analysis)
  - [Key Insights](#key-insights)
- [Data Preprocessing](#-data-preprocessing)
  - [Feature Selection](#feature-selection)
  - [Feature Scaling](#feature-scaling)
- [Finding the Optimal Number of Clusters](#-finding-the-optimal-number-of-clusters)
  - [Elbow Method (WCSS)](#elbow-method-wcss)
  - [Silhouette Score Validation](#silhouette-score-validation)
- [K-Means Clustering](#-k-means-clustering)
- [Cluster Evaluation](#-cluster-evaluation)
- [Cluster Visualisation](#-cluster-visualisation)
- [Business Profiling — Cluster Interpretation](#-business-profiling--cluster-interpretation)
  - [Cluster Profiles](#cluster-profiles)
  - [Marketing Strategy per Segment](#marketing-strategy-per-segment)
- [Segment Assignment Function](#-segment-assignment-function)
- [Future Improvements](#-future-improvements)
- [Project Structure](#-project-structure)
- [Author](#-author)

---

## 📌 Project Overview

This project applies **unsupervised machine learning** to identify natural groupings within a mall's customer base. Unlike supervised learning (where you train a model to predict a known label), clustering discovers hidden structure in data with no pre-defined categories.

Using **Annual Income** and **Spending Score** as the two key behavioural dimensions, K-Means clustering segments 200 customers into **5 distinct groups** — each with a unique business profile that can drive targeted marketing, loyalty programmes, and customer retention strategies.

```
EDA → Feature Selection → Scaling → Elbow Method → Silhouette Validation →
K-Means (k=5) → Cluster Evaluation → Visualisation → Business Profiling → Inference Function
```

---

## 🆕 What Makes This Different

This is an **unsupervised** project — a fundamental shift from the previous regression projects in this portfolio:

| Dimension | Supervised (Regression) | Unsupervised (Clustering) |
|---|---|---|
| **Goal** | Predict a known target value | Discover hidden groupings |
| **Labels** | Yes — e.g. house price, insurance charges | No — no target column exists |
| **Evaluation** | RMSE, MAE, R² | Silhouette Score, WCSS, visual inspection |
| **Output** | A predicted number | A cluster assignment (group ID) |
| **Train/Test split** | Required | Not used — model sees all data |

---

## 📂 Dataset

### Source

| Detail | Value |
|---|---|
| **Name** | Mall Customer Segmentation Data |
| **Source** | [Kaggle](https://www.kaggle.com/datasets/vjchoudhary7/customer-segmentation-tutorial-in-python/data) |
| **File** | `Mall_Customers.csv` |
| **Rows** | 200 customers |
| **Columns** | 5 (4 used for analysis after dropping CustomerID) |

### Features

| Column | Type | Description |
|---|---|---|
| `CustomerID` | Integer | Unique identifier — dropped before modelling (not informative) |
| `Gender` | Categorical | Male or Female — 112 Female (56%), 88 Male (44%) |
| `Age` | Numerical | Customer age in years |
| `Annual Income (k$)` | Numerical | Annual income in thousands of USD |
| `Spending Score (1-100)` | Numerical | Mall-assigned score reflecting purchase behaviour (1 = low, 100 = high) |

> **Modelling features used:** Only `Annual Income (k$)` and `Spending Score (1-100)` — these two dimensions produced the clearest visual cluster separation as confirmed in EDA.

### Key Statistics

| Feature | Mean | Median | Min | Max |
|---|---|---|---|---|
| Age | — | — | 18 | 70 |
| Annual Income (k$) | — | — | 15 | 137 |
| Spending Score (1-100) | — | — | 1 | 99 |
| Gender | 56% Female | — | — | — |

---

## 🔄 Project Workflow

```
┌─────────────┐    ┌─────────────┐    ┌──────────────────┐    ┌────────────────────┐
│  1. Setup   │ →  │  2. Load    │ →  │  3. EDA          │ →  │  4. Preprocessing  │
│  Libraries  │    │  Data       │    │  & Visualisation │    │  Feature Selection │
└─────────────┘    └─────────────┘    └──────────────────┘    └────────────────────┘
                                                                         │
┌──────────────────────┐    ┌───────────────────────┐    ┌──────────────────────────┐
│  9. Business         │ ←  │  8. Visualise         │ ←  │  5–7. Elbow → Silhouette │
│  Profiling           │    │  Clusters             │    │  → K-Means (k=5)         │
└──────────────────────┘    └───────────────────────┘    └──────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│  10. Segment Assignment │
│  Function / Inference   │
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
| `numpy` | Numerical computing |
| `matplotlib` / `seaborn` | Data visualisation and cluster plots |
| `sklearn.preprocessing.StandardScaler` | Feature scaling before clustering |
| `sklearn.cluster.KMeans` | K-Means clustering algorithm |
| `sklearn.metrics.silhouette_score` | Cluster quality evaluation |

---

## 🔍 Exploratory Data Analysis

EDA covers the following steps:

- **Schema inspection** — column types, shape, data types
- **Missing value check** — zero nulls confirmed across all columns
- **Encoded missing value check** — `value_counts()` per column to catch disguised nulls
- **Duplicate detection** — zero duplicates confirmed
- **Gender distribution** — countplot showing Female (56%) vs Male (44%)
- **Numeric distributions** — histograms + KDE for Age, Income, and Spending Score
- **Key scatter plot** — Income vs Spending Score on raw data, confirming visible cluster structure before modelling

### Key Insights

| Finding | Detail |
|---|---|
| **No missing values** | Fully clean dataset — no imputation required |
| **No duplicates** | All 200 rows are unique |
| **Gender split** | 112 Female, 88 Male — slight female majority |
| **Visible clusters** | The Income vs Spending scatter plot shows clear natural groupings even before any algorithm is applied |
| **Two modelling features chosen** | Annual Income and Spending Score capture behavioural and financial dimensions — the clearest axes for segmentation |
| **CustomerID dropped** | Not informative for clustering — saved separately to re-attach after cluster assignment |

---

## 🛠️ Data Preprocessing

### Feature Selection

`CustomerID` was saved to a list before being dropped from the DataFrame, then re-attached to the clustered output after modelling — so the final DataFrame links each customer to their assigned segment.

```python
# Save ID before dropping
customer_id = df["CustomerID"]
df = df.drop(columns=["CustomerID"])

# Select clustering features
columns_to_select = ["Annual Income (k$)", "Spending Score (1-100)"]
X = df[columns_to_select]
```

> **Why only 2 features?** Gender and Age were excluded from the clustering features to focus on the two dimensions that produced the clearest visual separation. A 2D clustering also allows straightforward scatter plot visualisation of results. Age and Gender are retained in the output DataFrame for profiling purposes.

### Feature Scaling

K-Means is a **distance-based algorithm** — it measures how close or far apart data points are. Without scaling, a feature with a large range (e.g. Income: 15–137) would dominate the distance calculations over a feature with a smaller range (e.g. Spending Score: 1–99).

```python
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
```

`StandardScaler` transforms each feature to zero mean and unit variance — ensuring both features contribute equally to the distance metric.

---

## 🔢 Finding the Optimal Number of Clusters

### Elbow Method (WCSS)

The **Within-Cluster Sum of Squares (WCSS)** — also called inertia — measures how tightly packed the points inside each cluster are. Lower WCSS = tighter clusters. K-Means was run for k = 1 through 10, and WCSS was plotted:

```python
wcss = []
for k in range(1, 11):
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans.fit(X_scaled)
    wcss.append(kmeans.inertia_)
```

**Elbow observations:**

| k | WCSS Behaviour |
|---|---|
| 1 → 2 | Very steep drop |
| 2 → 3 | Still a strong improvement |
| 3 → 4 | Noticeable but smaller improvement |
| **4 → 5** | **Clear change in slope — the elbow point** |
| 6 → 10 | Marginal gains only |

📌 **Conclusion: k = 5 is the elbow point.**

### Silhouette Score Validation

The silhouette score measures how well-separated clusters are from each other (range: -1 to +1 — higher is better). It was computed for k = 2 through 10 to validate the elbow method choice:

```python
for k in range(2, 11):
    model = KMeans(n_clusters=k, random_state=42, n_init=10)
    cluster_labels = model.fit_predict(X_scaled)
    sil = silhouette_score(X_scaled, cluster_labels)
```

**Final silhouette score at k = 5: 0.555** — indicating moderately well-separated, meaningful clusters.

---

## 🤖 K-Means Clustering

With k = 5 confirmed by both methods, the final model was fitted:

```python
K_FINAL = 5

kmeans_final = KMeans(
    n_clusters = K_FINAL,
    random_state = 42,
    n_init = 10       # run 10 initialisations, keep the best
)

kmeans_final.fit(X_scaled)
clusters = kmeans_final.predict(X_scaled)
```

Cluster labels were appended back to the original DataFrame alongside CustomerID:

```python
df_clusters["clusters"]    = clusters
df_clusters["CustomerID"]  = customer_id
```

---

## 📏 Cluster Evaluation

| Metric | Value | Interpretation |
|---|---|---|
| **Silhouette Score** | **0.555** | Moderately strong cluster separation — clusters are meaningfully distinct |
| **k chosen** | **5** | Supported by both Elbow method (WCSS) and Silhouette Score curve |
| **n_init** | 10 | Ran 10 random initialisations to avoid local minima in centroid placement |

> A silhouette score of 0.555 is a healthy result for real-world data — scores above 0.5 generally indicate clusters with reasonable cohesion and separation.

---

## 📊 Cluster Visualisation

The five clusters were plotted on an Income vs Spending Score scatter chart, colour-coded by cluster label:

```python
sns.scatterplot(
    x = df_clusters["Annual Income (k$)"],
    y = df_clusters["Spending Score (1-100)"],
    hue = df_clusters["clusters"],
    palette = "tab10",
    s = 80
)
```

![Cluster Visualisation](screenshots/cluster_scatter.png)

---

## 💼 Business Profiling — Cluster Interpretation

After clustering, each segment was profiled using mean and median statistics across Age, Annual Income, and Spending Score.

### Cluster Profiles

| Cluster | Business Label | Size | % of Customers | Avg Age | Avg Income | Avg Spending Score |
|---|---|---|---|---|---|---|
| **0** | 🟡 Middle Income — Average Spenders | 81 | 40.5% | 42.7 | $55.3k | 49.5 |
| **1** | 🟢 High Income — High Spenders *(Premium)* | 39 | 19.5% | 32.7 | $86.5k | 82.1 |
| **2** | 🔵 Low Income — High Spenders *(Impulsive)* | 22 | 11.0% | 25.3 | $25.7k | 79.4 |
| **3** | 🔴 High Income — Low Spenders *(Cautious)* | 35 | 17.5% | 41.1 | $88.2k | 17.1 |
| **4** | ⚪ Low Income — Low Spenders *(Budget)* | 23 | 11.5% | 45.2 | $26.3k | 20.9 |

**Total customers: 200**

### Marketing Strategy per Segment

| Cluster | Recommended Strategy |
|---|---|
| **0 — Average Spenders** | Loyalty programmes and moderate promotions — the largest segment. Incremental nudges to increase spend. |
| **1 — Premium** | VIP experiences, exclusive products, early access campaigns. High value, high return. |
| **2 — Impulsive** | Flash sales, limited-time offers, instalment payment options. High engagement but income-constrained. |
| **3 — Cautious** | Trust-building content, value-for-money messaging, quality guarantees. High income but resistant to spending. |
| **4 — Budget** | Discount-led campaigns, bundle deals, low-cost entry products. Price-sensitive segment. |

---

## 🧮 Segment Assignment Function

A reusable function was built to assign any new customer to a segment using the trained scaler and model:

```python
def assign_customer_segment(income_k, spending_score, scaler, model):
    new_point = pd.DataFrame(
        [[income_k, spending_score]],
        columns=["Annual Income (k$)", "Spending Score (1-100)"]
    )
    new_point_scaled = scaler.transform(new_point)
    cluster_id = model.predict(new_point_scaled)[0]
    return cluster_id
```

**Example usage:**

```python
assign_customer_segment(
    income_k       = 60,
    spending_score = 65,
    scaler         = scaler,
    model          = kmeans_final
)
# → Cluster 0 (Middle Income — Average Spender)
```

The function applies the **same StandardScaler** fitted on training data — ensuring new inputs are transformed consistently before prediction, avoiding scale mismatch errors.

---

## 🚀 Future Improvements

- **Include Age and Gender** — run a 3D or multi-feature clustering to incorporate all available dimensions, then use dimensionality reduction (PCA) to visualise
- **Try other clustering algorithms** — compare K-Means against DBSCAN (handles non-circular clusters) and Hierarchical Clustering (dendrogram-based k selection)
- **Automated elbow detection** — use the `kneed` library to programmatically identify the elbow point rather than visual inspection
- **Cluster stability testing** — run K-Means multiple times with different random seeds and compare cluster assignments to assess stability
- **Save the model** — persist the fitted `kmeans_final` and `scaler` with `joblib` for production deployment
- **Dashboard integration** — export `df_clusters` to Power BI or Tableau to build an interactive customer segment explorer

---

## 📁 Project Structure

```
customer-segmentation-clustering/
│
├── 15_6_customer_segmentation_clustering.ipynb   # Main notebook — full ML pipeline
├── Mall_Customers.csv                             # Dataset (download from Kaggle)
├── README.md                                      # Project documentation
└── screenshots/
    └── cluster_scatter.png                        # Add after exporting from notebook
```

--

**Michael Adeniran**
Data Analyst & Data Science Specialist | PL-300 Certified

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://linkedin.com)
[![Portfolio](https://img.shields.io/badge/Portfolio-View-black?logo=github)](https://github.com)

---

> *This project is part of a data science portfolio demonstrating unsupervised machine learning, cluster evaluation techniques, and business-oriented interpretation of data-driven customer segments using Python and scikit-learn.*
