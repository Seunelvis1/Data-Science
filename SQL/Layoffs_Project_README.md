# Layoffs Data Cleaning & Exploratory Data Analysis (SQL)

A two-part SQL project analyzing a global tech layoffs dataset — first cleaning the raw data into an analysis-ready table, then exploring it to surface layoff trends by company, industry, country, funding stage, and time.

## Project Structure

| File | Description |
|---|---|
| [`Data_Cleaning_Project_annotated.sql`](./Data_Cleaning_Project_annotated.sql) | Cleans the raw `layoffs` table: removes duplicates, standardizes text/date values, handles null and blank values, and drops helper columns |
| [`Layoffs_EDA_annotated.sql`](./Layoffs_EDA_annotated.sql) | Explores the cleaned table: company/industry/country/stage breakdowns, monthly rolling totals, and top-5-companies-per-year ranking |

The EDA script depends on the output of the data cleaning script — run `Data_Cleaning_Project_annotated.sql` first to produce `layoffs_staging3`, which the EDA script queries throughout.

## 1. Data Cleaning

Working from a raw `layoffs` table, the cleaning script:

- **Removes duplicates** — stages the raw data into a working copy, uses `ROW_NUMBER()` partitioned across every column to flag exact-duplicate rows, then deletes the extras
- **Standardizes the data** — trims whitespace from company names, consolidates inconsistent industry labels (e.g. multiple "Crypto" variants) into a single value, strips stray trailing punctuation from country names, and converts the date column from text into a proper `DATE` type
- **Handles nulls and blanks** — converts blank-string industries to `NULL`, backfills missing industry values from other rows for the same company via a self-join, and removes rows with no usable layoff figures at all
- **Drops helper columns** — removes the temporary `row_num` column once deduplication is complete

Output: a clean `layoffs_staging3` table ready for analysis.

## 2. Exploratory Data Analysis

Working from the cleaned table, the EDA script investigates:

- **Extremes** — the largest layoff events by headcount and by percentage, including every company that laid off 100% of staff
- **Breakdowns** — total layoffs grouped by company, industry, country, funding stage, and year
- **Time range** — the earliest and latest dates covered by the dataset
- **Trends over time** — monthly layoff totals, plus a rolling (cumulative) total built with a window function
- **Top performers per year** — the top 5 companies by total layoffs for each year in the dataset, using `DENSE_RANK()` partitioned by year

## Tech Stack

- MySQL
- Window functions (`ROW_NUMBER()`, `DENSE_RANK()`, cumulative `SUM() OVER()`)
- CTEs (including multi-CTE chains)
- Self-joins for null backfilling
