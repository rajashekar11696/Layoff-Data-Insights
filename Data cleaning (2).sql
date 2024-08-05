SELECT 
    *
FROM
    layoffs;

CREATE TABLE layoffs_staging LIKE layoffs;

SELECT 
    *
FROM
    layoffs_staging;

insert layoffs_staging 
select * from layoffs;

SELECT 
    *
FROM
    layoffs_staging;

Select *,
row_number() over (partition by Company,location,industry,total_laid_off,percentage_laid_off,date,
stage,country,funds_raised_millions)as row_num
from layoffs_staging;

With Duplicate_x as (Select *,
row_number() over (partition by Company,location,industry,total_laid_off,percentage_laid_off,date,
stage,country,funds_raised_millions)as row_num
from layoffs_staging)
Select * from Duplicate_x where row_num >1;

SELECT 
    *
FROM
    layoffs_staging
WHERE
    Company = 'Casper';

With Duplicate_x as (Select *,
row_number() over (partition by Company,location,industry,total_laid_off,percentage_laid_off,date,
stage,country,funds_raised_millions)as row_num
from layoffs_staging)
DELETE from Duplicate_x where row_num >1;

CREATE TABLE layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging2;

insert into layoffs_staging2
Select *,
row_number() over (partition by Company,location,industry,total_laid_off,percentage_laid_off,date,
stage,country,funds_raised_millions)as row_num
from layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    row_num > 1;
DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;

SELECT 
    *
FROM
    layoffs_staging2;
SET SQL_SAFE_UPDATES = 0;

SELECT 
    Company, TRIM(company)
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    company = TRIM(company);

SELECT DISTINCT
    Industry
FROM
    layoffs_staging2
ORDER BY 1;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    Country LIKE '%United States.%';

Update layoffs_staging2
set Country ="United States"  where Country Like "%United States.%"

select * from layoffs_staging2;

SELECT DISTINCT
    Country
FROM
    layoffs_staging2
ORDER BY 1;

SELECT DISTINCT
    Country, TRIM(Country)
FROM
    layoffs_staging2;

UPDATE layoffs_staging2 
SET 
    Country = TRIM(Country);
SELECT DISTINCT
    date
FROM
    layoffs_staging2;

-- Step 2: Update dates in 'MM/DD/YYYY' format
UPDATE layoffs_staging2 
SET 
    date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE
    date REGEXP '^[0-1][0-9]/[0-3][0-9]/[0-9]{4}$';

UPDATE layoffs_staging2 
SET 
    date = STR_TO_DATE(date, '%Y-%m-%d')
WHERE
    date REGEXP '^[0-9]{4}-[0-1][0-9]-[0-3][0-9]$';

UPDATE layoffs_staging2 
SET 
    date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE
    date REGEXP '^[0-1]?[0-9]/[0-3]?[0-9]/[0-9]{4}$';



-- Step 3: Update dates in 'DD-MM-YYYY' format
UPDATE layoffs_staging2 
SET 
    date = STR_TO_DATE(date, '%d-%m-%Y')
WHERE
    date REGEXP '^[0-3][0-9]-[0-1][0-9]-[0-9]{4}$';

-- Step 4: Update dates in 'YYYY-MM-DD' format
UPDATE layoffs_staging2 
SET 
    date = STR_TO_DATE(date, '%Y-%m-%d')
WHERE
    date REGEXP '^[0-9]{4}-[0-1][0-9]-[0-3][0-9]$';

Alter table layoffs_staging2
modify column date date;

SELECT 
    *
FROM
    layoffs_staging2;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL OR industry = '';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company = 'Airbnb';

SELECT 
    t1.industry, t2.industry
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;
 
UPDATE layoffs_staging2 
SET 
    industry = NULL
WHERE
    industry = '';
 
UPDATE layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company 
SET 
    t1.industry = t2.industry
WHERE
    t1.industry IS NULL
        AND t2.industry IS NOT NULL;
  
SELECT 
    *
FROM
    layoffs_staging2;
  
DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;
  
  Alter table layoffs_staging2 drop column row_num;
  
  
  
  








 
























































































