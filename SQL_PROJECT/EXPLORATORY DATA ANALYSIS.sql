-- EXPLORATORY DATA ANALYSIS


SELECT * 
FROM layoffs_stages3;


SELECT industry, total_laid_off, percentage_laid_off
FROM layoffs_stages3
GROUP BY industry, total_laid_off, percentage_laid_off
ORDER BY 2 DESC;


SELECT industry, MAX(total_laid_off),
ROW_NUMBER() OVER()
FROM layoffs_stages3
GROUP BY industry
ORDER BY 2 DESC;


SELECT *,
ROW_NUMBER() OVER()
FROM layoffs_stages3
;


SELECT *,
ROW_NUMBER() OVER()
FROM layoffs_stages3
WHERE industry LIKE '%legal%';


SELECT industry, company, SUM(total_laid_off) laid_off
FROM layoffs_stages3
GROUP BY industry, company
ORDER BY laid_off DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_stages3;


SELECT industry, SUM(total_laid_off) laid_off
FROM layoffs_stages3
GROUP BY industry
ORDER BY laid_off DESC;


SELECT country, SUM(total_laid_off) laid_off, SUM(percentage_laid_off)
FROM layoffs_stages3
GROUP BY country
ORDER BY laid_off DESC;


SELECT YEAR(`date`), SUM(total_laid_off) laid_off
FROM layoffs_stages3
GROUP BY YEAR(`date`)
ORDER BY laid_off DESC;

#`month` = SUBSTRING(`date`, 6,2) 


SELECT MONTH(`date`) `MONTH` 
FROM layoffs_stages3;


SELECT SUBSTRING(`date`, 1, 7)  `YEAR-MONTH`, SUM(total_laid_off)
FROM layoffs_stages3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY SUBSTRING(`date`, 1, 7);


WITH rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7)  `YEAR-MONTH`, SUM(total_laid_off) laid_off
FROM layoffs_stages3
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY SUBSTRING(`date`, 1, 7)
)
SELECT `YEAR-MONTH`, laid_off, 
SUM(laid_off) OVER(ORDER BY `YEAR-MONTH`) rolling_total
FROM rolling_total;


SELECT company, YEAR(`date`) years, SUM(total_laid_off) laid_off
FROM layoffs_stages3
GROUP BY company, years
ORDER BY laid_off DESC;

WITH Company_Year AS
(
SELECT company, YEAR(`date`) years, SUM(total_laid_off) laid_off
FROM layoffs_stages3
GROUP BY company, years
ORDER BY laid_off DESC
)
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY laid_off DESC) ranks
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY ranks;

WITH Company_Year AS
(
SELECT company, YEAR(`date`) years, SUM(total_laid_off) laid_off
FROM layoffs_stages3
GROUP BY company, years
ORDER BY laid_off DESC
),
Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY laid_off DESC) ranks
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranks < 6;

SELECT *
FROM layoffs_stages3;

SELECT industry, total_laid_off, percentage_laid_off, 
(total_laid_off/percentage_laid_off) * 100 total_employee
FROM layoffs_stages3
WHERE total_laid_off IS NOT NULL
AND percentage_laid_off IS NOT NULL
ORDER BY industry;

SELECT industry, 
(total_laid_off/percentage_laid_off) * 100 total_employee
FROM layoffs_stages3
WHERE total_laid_off IS NOT NULL
AND percentage_laid_off IS NOT NULL
GROUP BY industry, total_employee
ORDER BY industry;

WITH total_employee_industry AS
(
SELECT industry, total_laid_off, percentage_laid_off, 
(total_laid_off/percentage_laid_off) * 100 total_employee
FROM layoffs_stages3
WHERE total_laid_off IS NOT NULL
AND percentage_laid_off IS NOT NULL
ORDER BY industry
)
SELECT *, 
SUM(total_employee) OVER(PARTITION BY industry ORDER BY total_employee) rolling_total_employee
FROM total_employee_industry;