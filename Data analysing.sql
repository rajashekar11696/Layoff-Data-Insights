SELECT 
    *
FROM
    layoffs_staging2;

SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    layoffs_staging2;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY total_laid_off DESC;
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
 
SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
SELECT 
    MIN(date), MAX(date)
FROM
    layoffs_staging2;
SELECT 
    Country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY Country
ORDER BY 2 DESC;
SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
SELECT 
    YEAR(date), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;
SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;
SELECT 
    company, AVG(percentage_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
SELECT 
    SUBSTRING(date, 1, 7) AS month1, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY month1
ORDER BY 1 ASC;
with x as (SELECT substring(date,1,7) as month1, sum(total_laid_off) as totaloff from layoffs_staging2
where substring(date,1,7) is not null group by month1 order by 1 asc) 
select month1, totaloff,sum(totaloff) over (order by month1) as rolling_total from x;

SELECT 
    Company, YEAR(date), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(date) , company
ORDER BY 3 DESC; 

WITH X  (COMPANY,YEARS, total_laid_off)AS (SELECT 
    Company, YEAR(date),  SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(date),company
ORDER BY 3  DESC),
xrnk as (
SELECT *, DENSE_RANK() OVER (PARTITION BY YEARS ORDER BY total_laid_off desc) AS Rnk FROM X
where years is not NULL) 
select * from xrnk where rnk <= 5;




SELECT 
    *
FROM
    layoffs_staging2;


 






































































