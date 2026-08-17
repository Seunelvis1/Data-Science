-- ============================================================
-- Data Cleaning Project
-- ============================================================

-- Data Cleaning

SELECT * FROM layoffs;
-- Look at the raw source table before touching anything.

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove Any column
-- ^ These four comments are the project plan/checklist for the whole script.

-- 1. Remove Duplicates

CREATE TABLE layoffs_staging2
LIKE layoffs;
-- Create a new empty table with the exact same column structure as
-- "layoffs" (no data). This gives you a safe working copy so the
-- original raw table is never modified directly.

INSERT layoffs_staging2
SELECT *
FROM layoffs;
-- Copy all rows from the raw "layoffs" table into the new staging table.
-- From here on, all cleaning happens on layoffs_staging2, not the original.

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_um
FROM layoffs_staging2;
-- For every row, number it 1, 2, 3... within groups of rows that share
-- identical values across ALL of these columns. If a row is truly unique,
-- it gets row_um = 1. If two or more rows are exact duplicates of each
-- other, the 2nd, 3rd, etc. copies get row_um = 2, 3... This is how you
-- flag duplicates without a single-column unique key to rely on.
-- (Alias is spelled "row_um" here — likely meant to be "row_num";
-- doesn't break anything, it's just this query's own output name.)

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)  AS row_num
FROM layoffs_staging2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- Wrap the same row-numbering logic in a CTE so you CAN filter on it —
-- window function results can't be used directly in a WHERE clause on
-- the same SELECT, so this two-step (CTE, then filter) pattern is required.
-- Returns only the duplicate rows (row_num > 1), i.e. the extra copies
-- you'll eventually want to remove.

SELECT *
FROM layoffs_staging2
WHERE company = 'Casper';
-- Manually spot-check one specific company (Casper) to visually confirm
-- whether the rows flagged as duplicates above are genuinely duplicate
-- records, not just similar ones.

CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Build a new table, layoffs_staging3, with the same columns as before
-- PLUS an extra row_num column. This is needed because you can't DELETE
-- directly using a window function/CTE result in MySQL — so instead the
-- row numbers are materialized into a real, storable column here.

INSERT INTO layoffs_staging3
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)  AS row_num
FROM layoffs_staging2;
-- Populate layoffs_staging3 with every row from layoffs_staging2, this
-- time actually storing the row_num value in its own column so it can
-- be filtered/deleted on directly.

DELETE
FROM layoffs_staging3
WHERE row_num > 1;
-- Delete the duplicate rows — keep only the first occurrence (row_num = 1)
-- of each group of identical rows; every extra copy is removed.

SELECT *
FROM layoffs_staging3
WHERE row_num > 1;
-- Sanity check: confirm no rows with row_num > 1 remain (should return
-- zero rows if the delete above worked as intended).

DELETE
FROM layoffs_staging3
WHERE row_num > 1;
-- Duplicate of the DELETE two steps above — harmless no-op the second
-- time (nothing left to delete), but redundant and can be removed.

SELECT *
FROM layoffs_staging3;
-- View the deduplicated table.


-- 2. Standardize the Data

SELECT company, trim(company)
FROM layoffs_staging3;
-- Preview company names side-by-side with their TRIM()'d version, to see
-- which rows have leading/trailing whitespace that needs cleaning.

UPDATE layoff_staging3
SET company = trim(company);
-- Intended to overwrite the company column with the trimmed (whitespace-
-- stripped) version. *** BUG: table name is "layoff_staging3" (missing
-- the "s" — should be "layoffs_staging3"). As written, this will fail
-- with "Table 'layoff_staging3' doesn't exist". Correct it to:
--   UPDATE layoffs_staging3 SET company = TRIM(company);

SELECT distinct(industry)
FROM layoffs_staging3
Order by 1;
-- List every unique value that appears in the industry column, sorted
-- alphabetically, to visually spot inconsistent naming (e.g. "Crypto",
-- "Crypto Currency", "CryptoCurrency" all meaning the same industry).

SELECT *
FROM layoffs_staging3
WHERE industry LIKE 'Crypto%';
-- Preview every row where industry starts with "Crypto" (in any of its
-- inconsistent variants) before standardizing them.

UPDATE layoffs_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- Standardize all crypto-related industry variants into a single
-- consistent value: "Crypto".

SELECT DISTINCT(location)
FROM layoffs_staging3;
-- List every unique location value, to eyeball it for inconsistencies
-- the same way as was done for industry above.

UPDATE layoffs_staging3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
-- Fix country values like "United States." (with a stray trailing period)
-- by stripping any trailing "." characters, so "United States." and
-- "United States" become one consistent value.

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging3;
-- Preview the date column converted from its current text format
-- (M/D/YYYY, e.g. "3/14/2023") into a real MySQL DATE value, without
-- changing the table yet — just checking the conversion works correctly.

UPDATE layoffs_staging3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- Actually overwrite the date column with the converted date values.
-- Note: the column is still a TEXT type at this point — this just
-- changes the text content to a date-formatted string (e.g. YYYY-MM-DD).

ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;
-- Now that the values are stored in proper date format, change the
-- column's actual data type from TEXT to DATE, so it behaves like a
-- real date column (sortable, usable in date functions, etc.).

SELECT `date`
FROM layoffs_staging3;
-- Confirm the date column now looks correct and is typed as DATE.


-- 3. Null Values or blank values

SELECT *
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- Find rows where BOTH total_laid_off and percentage_laid_off are NULL —
-- these rows carry no usable layoff figures at all, so they're candidates
-- for removal later.

SELECT *
FROM layoffs_staging3
WHERE industry IS NULL
OR industry = '';
-- Find rows where industry is either NULL or an empty string — catches
-- both "missing" representations, since blank text isn't the same as
-- SQL NULL.

SELECT *
FROM layoffs_staging3
WHERE INDUSTRY IS NULL;
-- Narrower check: rows where industry is NULL specifically (column name
-- written in caps here — MySQL is case-insensitive for identifiers by
-- default, so this behaves the same as `industry`).

UPDATE layoffs_staging3
SET industry = NULL
WHERE industry = '';
-- Convert blank-string industries into proper NULLs, so every "missing"
-- value is represented the same way and can be handled consistently
-- (e.g. by the fill-in-from-matching-company step below).

SELECT t1.industry, t2.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;
-- Self-join the table to itself on company name: for each row (t1) with
-- a missing industry, find another row (t2) for the SAME company that
-- DOES have an industry filled in. Preview of what could be backfilled.

UPDATE layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
-- Actually perform the backfill: for any row missing an industry, copy
-- in the industry value from another row belonging to the same company
-- that already has one filled in.

DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- Remove rows that have no usable layoff data at all (both key metric
-- columns NULL) — these rows aren't useful for analysis, so they're
-- dropped from the cleaned table.

SELECT *
FROM layoffs_staging3;
-- View the table after null-handling and row removal.


-- 4. Remove Any column

ALTER TABLE layoffs_staging3
DROP COLUMN row_num;
-- Drop the row_num helper column — it was only needed to identify and
-- delete duplicates earlier, and serves no purpose in the final cleaned
-- table, so it's removed as the last step.