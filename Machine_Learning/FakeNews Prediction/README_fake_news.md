# 📰 Fake News Prediction — NLP Text Classification

> A Natural Language Processing (NLP) project that classifies news articles as **Real** or **Fake** using TF-IDF vectorisation and Logistic Regression — introducing text cleaning, feature engineering from raw text, and a full NLP pipeline across 72,134 articles from the WELFake dataset.

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![scikit-learn](https://img.shields.io/badge/scikit--learn-1.x-orange?logo=scikit-learn)](https://scikit-learn.org/)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-20BEFF?logo=kaggle)](https://www.kaggle.com/datasets/saurabhshahane/fake-news-classification)
[![ML Type](https://img.shields.io/badge/ML%20Type-NLP%20Classification-blueviolet)]()
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen)]()

---

## 📑 Table of Contents

- [Project Overview](#-project-overview)
- [What Makes This Project Different](#-what-makes-this-project-different)
- [Dataset](#-dataset)
  - [Source](#source)
  - [Schema](#schema)
  - [Class Distribution](#class-distribution)
  - [Sampling Strategy](#sampling-strategy)
- [Project Workflow](#-project-workflow)
- [Setup & Installation](#-setup--installation)
  - [Prerequisites](#prerequisites)
  - [Install Dependencies](#install-dependencies)
- [Exploratory Data Analysis](#-exploratory-data-analysis)
  - [Key Insights](#key-insights)
- [Data Preprocessing](#-data-preprocessing)
  - [Handling Missing Values](#handling-missing-values)
  - [Text Cleaning](#text-cleaning)
  - [Feature Engineering](#feature-engineering)
  - [Content Column Creation](#content-column-creation)
  - [Train/Test Split](#traintest-split)
- [Vectorisation — TF-IDF](#-vectorisation--tf-idf)
  - [What TF-IDF Does](#what-tf-idf-does)
  - [TF-IDF Configuration](#tf-idf-configuration)
  - [Why No StandardScaler Here](#why-no-standardscaler-here)
- [Model Training Pipeline](#-model-training-pipeline)
- [Model Evaluation](#-model-evaluation)
  - [Training Performance](#training-performance)
  - [Test Performance](#test-performance)
  - [Confusion Matrix](#confusion-matrix)
- [Predictive System](#-predictive-system)
- [What's Next — Roadmap](#-whats-next--roadmap)
- [Future Improvements](#-future-improvements)
- [Project Structure](#-project-structure)
- [Author](#-author)

---

## 📌 Project Overview

This project builds an end-to-end **Natural Language Processing pipeline** to detect fake news articles. Unlike previous projects in this portfolio that worked with numerical tabular data, this project starts from **raw text** — messy, unstructured, variable-length news articles — and transforms it into machine-learnable features using **TF-IDF vectorisation**.

A **Logistic Regression** classifier is trained on a balanced 20,000-article sample from the 72,134-article WELFake dataset, achieving **93.53% test accuracy** without any hyperparameter tuning — demonstrating the power of TF-IDF as a text feature extractor even with a simple linear model.

```
Load Data → Balanced Sample → EDA → Text Cleaning →
Feature Engineering → TF-IDF Vectorisation → Logistic Regression →
Evaluation → Predictive System
```

---

## 🆕 What Makes This Project Different

This is the first **NLP project** in this portfolio — introducing an entirely new class of data and preprocessing techniques:

| Dimension | Tabular ML (Previous Projects) | NLP (This Project) |
|---|---|---|
| **Input data** | Structured numbers and categories | Raw unstructured text |
| **Preprocessing** | StandardScaler, OneHotEncoder, Imputer | Text cleaning, Regex, TF-IDF |
| **Feature creation** | Columns already exist as features | Features are *created* from words |
| **Dimensionality** | Typically 5–30 features | Up to 50,000 TF-IDF features |
| **Scaling** | StandardScaler required | Not needed — TF-IDF already normalised |
| **Key challenge** | Missing values, outliers, skew | Noise words, HTML, URLs, case variation |
| **Model** | Random Forest, SVM, HistGB | Logistic Regression on sparse vectors |

---

## 📂 Dataset

### Source

| Detail | Value |
|---|---|
| **Name** | WELFake Dataset |
| **Source** | [Kaggle](https://www.kaggle.com/datasets/saurabhshahane/fake-news-classification) |
| **File** | `WELFake_Dataset.csv` |
| **Full dataset rows** | 72,134 articles |
| **Sampled rows (used)** | 20,000 (10,000 Fake + 10,000 Real) |
| **Columns** | 4 (3 used after dropping index) |

### Schema

| Column | Type | Description |
|---|---|---|
| `Unnamed: 0` | Integer | Row index — dropped immediately (not informative) |
| `title` | Text | News article headline |
| `text` | Text | Full body of the news article |
| `label` | Integer (Binary) | **Target** — 0 = Fake, 1 = Real |

> **Combined feature used for modelling:** `content` = `title` + `" "` + `text`, after text cleaning — concatenating headline and body captures both the framing (title) and substance (text) of a news article.

### Class Distribution

**Full dataset (72,134 articles):**

| Class | Label | Count | Percentage |
|---|---|---|---|
| Real | 1 | 37,106 | 51.4% |
| Fake | 0 | 35,028 | 48.6% |

**After sampling and dropping nulls (19,856 articles used for modelling):**

| Class | Label | Count | Percentage |
|---|---|---|---|
| Fake | 0 | 10,000 | 50.4% |
| Real | 1 | 9,856 | 49.6% |

> Near-perfect class balance — no class weighting or SMOTE required, unlike the Breast Cancer project.

### Sampling Strategy

The full 72,134-article dataset was subsampled to 20,000 articles (10,000 per class) to reduce compute requirements while preserving class balance:

```python
df_fake_sample = df_fake.sample(10000, random_state=42)
df_real_sample = df_real.sample(10000, random_state=42)

df = (pd.concat([df_fake_sample, df_real_sample])
        .sample(frac=1, random_state=42)   # shuffle
        .reset_index(drop=True))
```

> Stratified sampling before combining ensures each class contributes equally, then shuffling prevents any ordering effects during training.

---

## 🔄 Project Workflow

```
┌──────────────┐    ┌───────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  1. Setup    │ →  │  2. Load & Sample │ →  │  3. EDA &        │ →  │  4. Text         │
│  Libraries   │    │  20K articles     │    │  Visualisation   │    │  Cleaning        │
└──────────────┘    └───────────────────┘    └──────────────────┘    └──────────────────┘
                                                                               │
┌──────────────────────┐    ┌────────────────────────┐    ┌──────────────────────────────┐
│  6. Evaluation       │ ←  │  5. Pipeline           │ ←  │  Feature Engineering         │
│  Confusion Matrix    │    │  TF-IDF + Logistic     │    │  content = title + text      │
└──────────────────────┘    └────────────────────────┘    └──────────────────────────────┘
         │
         ▼
┌─────────────────────────┐
│  7. Predictive System   │
│  predict_news()         │
└─────────────────────────┘
```

---

## ⚙️ Setup & Installation

### Prerequisites

- Python 3.8 or higher
- pip
- The WELFake dataset requires significant RAM to load fully (~72K rows of long text). A machine with at least 8GB RAM is recommended, or use Google Colab with the Kaggle API.

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
| `pandas` | Data loading, cleaning, and manipulation |
| `numpy` | Numerical operations |
| `matplotlib` / `seaborn` | Visualisations — class distribution, text length plots |
| `re` | Regular expressions for text cleaning |
| `collections.Counter` | Word frequency analysis |
| `sklearn.feature_extraction.text.TfidfVectorizer` | Convert text → numerical TF-IDF feature matrix |
| `sklearn.feature_extraction.text.ENGLISH_STOP_WORDS` | Reference list of common English words to filter |
| `sklearn.linear_model.LogisticRegression` | Binary classification model |
| `sklearn.pipeline.Pipeline` | Chain TF-IDF and model into one object |
| `sklearn.metrics` | Accuracy, classification report, confusion matrix |

---

## 🔍 Exploratory Data Analysis

EDA covers the following steps:

- **Schema inspection** — 3 columns post-drop: `title`, `text`, `label`
- **Missing value analysis** — `title`: 133 nulls, `text`: 11 nulls, `label`: 0 nulls
- **Class distribution** — countplot confirming near-equal balance (50/50)
- **Text length analysis** — new columns added: `title_len_chars`, `text_len_chars`, `content_len_word`
- **Content length boxplot** — word count distribution comparing Fake vs Real articles, outliers excluded

### Key Insights

| Finding | Detail |
|---|---|
| **Missing values in text columns** | 133 missing titles, 11 missing texts — dropped (144 rows, <1% of sample) |
| **Near-perfect class balance** | 50.4% Fake / 49.6% Real after dropping nulls — no resampling needed |
| **Text length varies widely** | Average article is 558 words; range is 0–21,284 words |
| **Title length is consistent** | Average title is 77 characters; range 4–286 |
| **Real vs Fake text length** | Boxplot shows similar word-count distributions — length alone does not differentiate |
| **No traditional features** | The only useful signal is in the raw text — requires NLP preprocessing |

---

## 🛠️ Data Preprocessing

### Handling Missing Values

Missing rows (133 null titles + 11 null texts) were dropped rather than imputed — text imputation is unreliable, and 144 rows represent less than 1% of the 20,000-article sample:

```python
df = df.dropna()
# 20,000 → 19,856 rows retained
```

### Text Cleaning

A custom `clean_text()` function was applied to all articles:

```python
def clean_text(s: str) -> str:
    if pd.isna(s):
        return ""
    s = str(s).lower()                                      # lowercase
    s = re.sub(r"http\S+|www\.\S+", " ", s)                # remove URLs
    s = re.sub(r"<.*?>", " ", s)                            # remove HTML tags
    s = re.sub(r"[^a-z0-9\s\.\,\!\?\-\']", " ", s)        # keep basic chars
    s = re.sub(r"\s+", " ", s).strip()                     # normalise spaces
    return s
```

**What each step removes:**

| Step | Removes | Why |
|---|---|---|
| Lowercase | Capital variation | "Obama" and "obama" should be the same token |
| URL removal | `http://...`, `www....` | URLs add noise, not meaning |
| HTML tag removal | `<p>`, `<br>`, `<div>` etc. | Web-scraped articles often contain HTML fragments |
| Special characters | `*`, `@`, `#`, emoji etc. | Non-informative for classification |
| Space normalisation | Multiple spaces, tabs | Ensures clean tokenisation downstream |

### Feature Engineering

Three analytical columns were created for EDA (not used in modelling):

```python
df["title_len_chars"]  = df["title"].str.len()
df["text_len_chars"]   = df["text"].str.len()
df["content_len_word"] = df["content"].str.split().apply(len)
```

### Content Column Creation

Title and text were concatenated into a single `content` column before cleaning:

```python
df["content"] = (df["title"] + " " + df["text"]).apply(clean_text)
```

> Concatenating title and body ensures the model can exploit signals from both the headline framing and the article substance — two complementary sources of fake news indicators.

### Train/Test Split

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y,
    test_size    = 0.2,
    stratify     = y,        # preserve class balance in both splits
    random_state = 42
)
# Train: 15,884 articles  |  Test: 3,972 articles
```

---

## 🔤 Vectorisation — TF-IDF

### What TF-IDF Does

TF-IDF converts raw text into a numerical matrix where each row is a document (article) and each column is a word/phrase. The value in each cell reflects how *important* that word is to that specific document:

```
TF-IDF(word, document) = TF(word, document) × IDF(word, all documents)

TF  = how often the word appears in this article
IDF = log(total articles / articles containing this word)
```

**Intuition:**

| Word | TF | IDF | TF-IDF | Why |
|---|---|---|---|---|
| "the" | High | Very low | ≈ 0 | Appears in every article — uninformative |
| "election" | Medium | Medium | Medium | Common in news but meaningful |
| "fabricated" | High in one article | High | High | Rare globally, frequent locally — strong signal |

### TF-IDF Configuration

```python
TfidfVectorizer(
    max_features = 50000,       # top 50,000 most frequent tokens retained
    ngram_range  = (1, 2),      # unigrams ("election") AND bigrams ("fake election")
    stop_words   = "english",   # remove common English words (the, is, and...)
    min_df       = 2            # ignore tokens appearing in fewer than 2 documents
)
```

| Parameter | Value | Purpose |
|---|---|---|
| `max_features` | 50,000 | Caps vocabulary size — controls memory and avoids overfitting on rare words |
| `ngram_range` | (1, 2) | Captures single words AND two-word phrases — "white house" is more informative than "white" alone |
| `stop_words` | "english" | Removes 318 common English words that carry no classification signal |
| `min_df` | 2 | Removes words seen in only one article — these are likely typos or proper nouns unique to one story |

### Why No StandardScaler Here

```
NOTE: TF-IDF already produces normalised numerical features.
Each value represents a word importance weight — not a raw magnitude.
StandardScaler is not applied in NLP pipelines.
```

TF-IDF's IDF component already downweights common terms globally. The resulting matrix is sparse (most values are 0) and already scaled — applying StandardScaler would destroy the sparsity and dramatically increase memory usage.

---

## 🤖 Model Training Pipeline

TF-IDF and Logistic Regression are chained into a single `Pipeline`:

```python
model_pipeline = Pipeline(steps=[
    ("tfidf", TfidfVectorizer(
        max_features = 50000,
        ngram_range  = (1, 2),
        stop_words   = "english",
        min_df       = 2
    )),
    ("model", LogisticRegression())
])

model_pipeline.fit(X_train, y_train)
```

> The pipeline ensures TF-IDF is fitted only on training data — the vocabulary and IDF weights are learned from training articles only, then applied to test articles. This prevents information from the test set leaking into feature construction.

**Why Logistic Regression for NLP?**

Despite its name, Logistic Regression is a classification algorithm. It works exceptionally well with TF-IDF features because:
- TF-IDF produces high-dimensional but sparse feature vectors — LR handles sparse data efficiently
- The decision boundary for fake vs real news is approximately linear in TF-IDF space
- LR is fast to train even with 50,000 features
- LR with `predict_proba()` outputs interpretable confidence scores

---

## 📊 Model Evaluation

### Training Performance

| Metric | Fake (0) | Real (1) | Overall |
|---|---|---|---|
| **Precision** | 0.9655 | 0.9535 | — |
| **Recall** | 0.9536 | 0.9654 | — |
| **F1-Score** | 0.9595 | 0.9594 | — |
| **Accuracy** | — | — | **95.95%** |

### Test Performance

| Metric | Fake (0) | Real (1) | Overall |
|---|---|---|---|
| **Precision** | 0.9399 | 0.9307 | — |
| **Recall** | 0.9310 | 0.9397 | — |
| **F1-Score** | 0.9354 | 0.9352 | — |
| **Accuracy** | — | — | **93.53%** |

> **Train–Test gap:** 95.95% → 93.53% — a 2.4pp drop. Moderate overfitting, expected given no regularisation tuning was applied. The model still generalises strongly to unseen articles.

### Confusion Matrix

**Test set (3,972 articles):**

```
                   Predicted Fake    Predicted Real
Actual Fake            1,862              138
Actual Real              119            1,853
```

| Outcome | Count | Meaning |
|---|---|---|
| True Negatives | 1,862 | Fake articles correctly identified ✅ |
| True Positives | 1,853 | Real articles correctly identified ✅ |
| False Positives | 138 | Real articles incorrectly flagged as Fake |
| False Negatives | 119 | Fake articles incorrectly passed as Real ⚠️ |

![Confusion Matrix](screenshots/confusion_matrix_test.png)

> In the context of fake news detection, **False Negatives (fake articles labelled as real)** are the more costly error — they allow misinformation to pass undetected. Future work should consider optimising for Recall on the Fake class, as was done for Malignant tumours in the Breast Cancer project.

---

## 🧮 Predictive System

A reusable function accepts a news article's title and body text and returns a prediction:

```python
def predict_news(title, text):
    combined = clean_text(f"{title} {text}")
    prediction = model_pipeline.predict([combined])
    if prediction[0] == 1:
        print("This is Real News 🟢")
    else:
        print("This is Fake News 🔴")
```

**Example prediction:**

```python
predict_news(
    title = "Breaking: Government announces new economic policy",
    text  = "The finance minister introduced a new policy today after discussions in parliament..."
)
# → [1]
# → This is Real News 🟢
```

The function applies `clean_text()` before passing to the pipeline — ensuring the same cleaning steps used in training are applied to new inputs. The TF-IDF vectoriser then maps the cleaned text to the same 50,000-feature vocabulary learned during training.

---

## 🗺️ What's Next — Roadmap

The notebook explicitly identifies the following next steps:

```python
# What Next?
# - Try cross validation
# - Model selection
# - Hyperparameter tuning
```

These improvements would complete the project to the same standard as the supervised regression and classification projects in this portfolio — see Future Improvements below.

---

## 🚀 Future Improvements

- **Cross-validation** — apply 5-fold stratified CV to get a more robust estimate of generalisation performance before touching the test set
- **Model selection** — benchmark Logistic Regression against Multinomial Naive Bayes (a classic NLP baseline), LinearSVC, and a gradient boosting model on TF-IDF features
- **Hyperparameter tuning** — GridSearchCV over `TfidfVectorizer` params (`max_features`, `ngram_range`) and `LogisticRegression` params (`C`, `solver`) to close the train–test gap
- **Recall optimisation** — tune the classification threshold or use `class_weight="balanced"` to prioritise catching Fake articles (reduce False Negatives)
- **Full dataset training** — remove the 20,000-article cap and train on all 72,134 articles with a compute-appropriate environment (Colab Pro or cloud VM)
- **Advanced NLP** — replace TF-IDF with sentence embeddings (e.g. `sentence-transformers`, `spaCy`) for richer semantic representations
- **ROC-AUC curve** — plot the ROC curve using `predict_proba` outputs to evaluate discrimination at all thresholds
- **Model persistence** — save the fitted pipeline with `joblib` for deployment in a content moderation API

---

## 📁 Project Structure

```
fake-news-prediction/
│
├── fake_news_prediction.ipynb     # Main notebook — full NLP pipeline
├── WELFake_Dataset.csv            # Source dataset (download from Kaggle)
├── README.md                      # Project documentation
└── screenshots/
    ├── class_distribution.png     # Add after exporting from notebook
    ├── text_length_boxplot.png    # Add after exporting from notebook
    └── confusion_matrix_test.png  # Add after exporting from notebook
```

> ⚠️ `WELFake_Dataset.csv` is ~150MB. Add it to `.gitignore` and link to the Kaggle source in the README, or use Git LFS if you need it in the repo.

---

## 👤 Author

**Michael Adeniran**
Data Analyst & Data Science Specialist | PL-300 Certified

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin)](https://linkedin.com)
[![Portfolio](https://img.shields.io/badge/Portfolio-View-black?logo=github)](https://github.com)

---

> *This project is part of a data science portfolio demonstrating Natural Language Processing (NLP), TF-IDF vectorisation, text classification, and end-to-end pipeline design for unstructured text data using Python and scikit-learn.*
