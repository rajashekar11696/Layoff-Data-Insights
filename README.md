## Project Overview: Layoff Data Analysis and Cleaning

**Goal:** To clean, analyze, and derive insights from a dataset containing layoff information.

**Key Steps:**

1. **Data Preparation:**
   * Create a staging area to isolate data cleaning processes.
   * Identify and remove duplicate records based on key fields.
   * Standardize data formats for columns like `company`, `country`, and `date`.
   * Handle missing values in critical columns like `total_laid_off` and `percentage_laid_off`.

2. **Exploratory Data Analysis (EDA):**
   * Calculate summary statistics (max, min, average) for key metrics.
   * Identify trends and patterns in layoff data over time.
   * Analyze layoffs by industry, company, and region.

3. **In-Depth Analysis:**
   * Calculate key performance indicators (KPIs) related to layoffs.
   * Explore relationships between different variables (e.g., company size, industry, layoff percentage).
   * Identify potential outliers or anomalies in the data.

**Overall Objective:**
To transform raw layoff data into clean, structured information that can be used to understand layoff trends, identify impacted industries and regions, and support data-driven decision making.
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**Data Cleaning Steps:**

1. **Create a Staging Table (`layoffs_staging`):**
    - This table is a copy of the original `layoffs` table, allowing you to modify data without affecting the raw data.
2. **Identify and Remove Duplicates:**
    - You identify duplicates by grouping rows with identical values in all columns (including the newly added `row_num` for ordering).
    - Rows with `row_num` greater than 1 are considered duplicates and deleted.
3. **Standardize Data:**
    - You remove leading/trailing spaces from the `Company` and `Country` columns using `TRIM()`.
    - You standardize the format of the `Country` column (e.g., "United States" instead of variations).
4. **Handle Dates:**
    - You attempt to convert various date formats (MM/DD/YYYY, YYYY-MM-DD, DD-MM-YYYY) using `STR_TO_DATE()`.
    - You modify the `date` column to a dedicated `DATE` data type.
5. **Clean Industry:**
    - You identify empty or null values in the `industry` column.
    - You use a JOIN to find companies with non-empty industries and update companies with missing industries.
    - Finally, you set empty industry values to NULL for consistency.
6. **Handle Missing Values (Total Laid Off & Percentage Laid Off):**
    - You delete rows where both `total_laid_off` and `percentage_laid_off` are null.
7. **Drop Unnecessary Column (`row_num`):**
    - The `row_num` column served its purpose for identifying duplicates and can be removed after cleaning.

**Data Analysis Queries:**

1. **Overall Data View:**
    - `SELECT * FROM layoffs_staging2;` displays the cleaned data.
2. **Maximum Values:**
    - `SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_staging2;` finds the highest values in each column.
3. **100% Layoffs:**
    - These queries identify companies with 100% layoffs, ordered by either total laid off or funds raised millions:
        - `SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY total_laid_off DESC;`
        - `SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY funds_raised_millions DESC;`
4. **Total Layoffs by Company:**
    - `SELECT company, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY company ORDER BY 2 DESC;` calculates the total number of layoffs for each company, sorted by the highest number.
5. **Date Range:**
    - `SELECT MIN(date), MAX(date) FROM layoffs_staging2;` finds the minimum and maximum dates in the dataset.
6. **Total Layoffs by Country:**
    - `SELECT Country, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY Country ORDER BY 2 DESC;` calculates the total number of layoffs for each country, sorted by the highest number.
7. **Total Layoffs by Industry:**
    - `SELECT industry, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY industry ORDER BY 2 DESC;` calculates the total number of layoffs for each industry, sorted by the highest number.
8. **Total Layoffs by Year:**
    - `SELECT YEAR(date), SUM(total_laid_off) FROM layoffs_staging2 GROUP BY YEAR(date) ORDER BY 1 DESC;` calculates the total number of layoffs for each year, sorted by year (descending).
9. **Total Layoffs by Stage:**
    - `SELECT stage, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY stage ORDER BY 1 DESC;` calculates the total number of layoffs for each stage (e.g., Series A, Series B), sorted by the highest number.
10. **Average Layoff Percentage by Company:**
    - `SELECT company, AVG(percentage_laid_off) FROM layoffs_staging2 GROUP BY company ORDER BY 2 DESC;` calculates the average percentage of layoffs for each company, sorted by the highest average.
11. **Monthly Layoff Trends:**
    - These queries calculate the total layoffs per month and a rolling total:
        - `SELECT SUBSTRING(date, 1, 7) AS month1, SUM(total_laid_off) FROM layoffs_staging2 WHERE substring(date,1,7) is not null group by month1 order by 1 asc) 
select month1, totaloff,sum(totaloff) over (order by month1) as rolling_total from x


## Top Findings

1. **Total Laid Off by Company**:
   - Companies with the highest total layoffs can be identified, highlighting those most affected during the layoff period.

2. **Industry Trends**:
   - The industries with the highest and lowest total layoffs can be identified, providing insights into which sectors were most impacted.

3. **Geographical Distribution**:
   - Countries with the highest total layoffs can be analyzed to understand the geographical distribution of layoffs.

4. **Yearly Trends**:
   - The trend of layoffs over the years, including the years with the highest and lowest layoffs.

5. **Monthly Trends**:
   - The months with the highest and lowest layoffs, which can help in identifying any seasonal trends in layoffs.

6. **Company-Specific Insights**:
   - Companies with the highest average percentage of layoffs, giving a perspective on the relative impact of layoffs within companies.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Key Performance Indicators (KPIs)

1. **Total Laid Off by Company**:
   ```sql
   SELECT company, SUM(total_laid_off) AS total_laid_off
   FROM layoffs_staging
   GROUP BY company
   ORDER BY total_laid_off DESC;
   ```

2. **Total Laid Off by Industry**:
   ```sql
   SELECT industry, SUM(total_laid_off) AS total_laid_off
   FROM layoffs_staging
   GROUP BY industry
   ORDER BY total_laid_off DESC;
   ```

3. **Total Laid Off by Country**:
   ```sql
   SELECT country, SUM(total_laid_off) AS total_laid_off
   FROM layoffs_staging
   GROUP BY country
   ORDER BY total_laid_off DESC;
   ```

4. **Total Laid Off by Year**:
   ```sql
   SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
   FROM layoffs_staging
   GROUP BY year
   ORDER BY year DESC;
   ```

5. **Total Laid Off by Month**:
   ```sql
   SELECT SUBSTRING(date, 1, 7) AS month, SUM(total_laid_off) AS total_laid_off
   FROM layoffs_staging
   GROUP BY month
   ORDER BY month ASC;
   ```

6. **Top 5 Companies by Layoffs Each Year**:
   ```sql
   WITH X AS (
       SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off
       FROM layoffs_staging
       GROUP BY YEAR(date), company
       ORDER BY total_laid_off DESC
   ),
   xrnk AS (
       SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS rnk
       FROM X
       WHERE year IS NOT NULL
   )
   SELECT * FROM xrnk
   WHERE rnk <= 5;
   ```

7. **Average Percentage Laid Off by Company**:
   ```sql
   SELECT company, AVG(percentage_laid_off) AS avg_percentage_laid_off
   FROM layoffs_staging
   GROUP BY company
   ORDER BY avg_percentage_laid_off DESC;
   ```

## Usage of Findings

1. **Strategic Planning**:
   - Use the data to understand which companies and industries are most vulnerable to layoffs. This can help in making strategic decisions for investment or policy-making.

2. **Economic Analysis**:
   - Analyze the impact of layoffs on different sectors and regions to guide economic policies and workforce development programs.

3. **Trend Identification**:
   - Identify trends in layoffs over time, such as seasonal patterns or economic cycles, to better predict future layoffs and prepare accordingly.

4. **Company Performance**:
   - Evaluate the performance and stability of companies based on their layoff data, providing insights for stakeholders, investors, and analysts.

5. **Geographical Focus**:
   - Understand the geographical distribution of layoffs to focus support and resources on the most affected areas.

6. **Industry Support**:
   - Identify industries that need support based on their layoff trends, guiding government and organizational interventions.

These KPIs and findings can be included in dashboards and reports to provide actionable insights for decision-makers. They help in monitoring the health of industries and companies, guiding strategic decisions, and shaping policies to support economic stability and growth.
