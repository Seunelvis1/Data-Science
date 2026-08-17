-- ============================================================
-- Layoffs EDA
-- ============================================================

-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging3;
-- View the full cleaned dataset as the starting point for analysis.

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;
-- Find the single largest layoff event by headcount, and separately the
-- highest percentage laid off recorded in the dataset (these two maxes
-- can come from different rows/companies — this just gives the extremes).

SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;
-- Look at every company that laid off 100% of staff (percentage_laid_off
-- = 1 means the whole workforce), sorted by headcount so the biggest
-- full shutdowns appear first.

SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- Same "100% laid off" companies as above, but sorted by how much
-- funding they'd raised — a way to spot well-funded companies that
-- still shut down completely.

SELECT company, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC;
-- Total layoffs per company, added up across all their entries (a
-- company can appear multiple times in the raw data, e.g. layoffs on
-- different dates), ranked from highest total to lowest.

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging3;
-- Find the earliest and latest dates in the dataset, to know the full
-- time range the data covers.

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC;
-- Total layoffs per industry, ranked highest to lowest — shows which
-- sectors were hit hardest overall.

SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC;
-- Total layoffs per country, ranked highest to lowest.

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;
-- Total layoffs per calendar year, ranked by size rather than
-- chronologically — shows which year was worst for layoffs overall.

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC;
-- Total layoffs grouped by company funding stage (e.g. Post-IPO, Series
-- B, etc.), ranked highest to lowest — shows which stage of company was
-- hit hardest.

SELECT substring(`date`,1,7) as `MONTH`, SUM(total_laid_off)
FROM layoffs_staging3
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;
-- Extract the "YYYY-MM" portion of each date (first 7 characters) to
-- group layoffs by month instead of by exact day. Filters out rows
-- where that substring would be NULL (i.e. date itself is NULL), then
-- lists total layoffs per month in chronological order.

WITH  Rolling_total AS
(
SELECT substring(`date`,1,7) as `MONTH`, SUM(total_laid_off) AS Total_laid_off
FROM layoffs_staging3
WHERE substring(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, Total_laid_off,
SUM(Total_laid_off) OVER(ORDER BY `MONTH`) AS Rolling_total
from Rolling_total;
-- Build on the monthly totals above by adding a running (cumulative)
-- total: for each month, Rolling_total = sum of that month's layoffs
-- plus every month before it. Useful for showing the cumulative
-- layoff count building up over time.
-- Note: the ORDER BY inside the CTE isn't guaranteed to carry through
-- to the outer SELECT in MySQL — the final row order is only reliably
-- guaranteed by the outer window function's OVER(ORDER BY `MONTH`), not
-- by the ORDER BY written inside the CTE itself.

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;
-- Total layoffs per company per year (so the same company can appear
-- once per year it had layoffs), ranked by size — a step toward finding
-- each year's biggest layoff events by company.

WITH Company_Year (Company, Years, Total_Laid_Off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY Years ORDER BY Total_Laid_Off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
-- Two-step CTE to find the top 5 companies by layoffs, per year:
-- 1) Company_Year: same company/year/total-layoffs aggregation as above,
--    but explicitly named and aliased (Company, Years, Total_Laid_Off)
--    so the next step can reference clean column names.
-- 2) Company_Year_Rank: within each year (PARTITION BY Years), rank
--    companies from highest to lowest total layoffs using DENSE_RANK
--    (ties share the same rank, no gaps in the ranking sequence), while
--    excluding rows where Years is NULL (i.e. rows with no valid date).
-- Final SELECT keeps only Ranking <= 5, giving the top 5 companies by
-- layoffs for every year in the dataset.