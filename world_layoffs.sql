# rough sketches of steps
# 1. create schema `world_layoffs` 
# 2. using the table data import wizard, located layoffs.csv file and loaded it

# to inspect data 
# run `USE world_layoffs` (to use the world_layoffs schema we created)

SELECT *
FROM layoffs;

# from inspecting, we need to:
# remove duplicates
# standardize data
# remove/populate blanks and nulls
# remove irrelevant column
# bonus step: convert the date column to date type from text

# duplicate original table for safety
CREATE TABLE layoffs_staging
LIKE layoffs;

# copy from layoffs to layoffs_staging
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

# check for duplicates
WITH duplicates AS (
	SELECT *,
    ROW_NUMBER() OVER(PARTITION BY 
		company,
        location,
        industry,
        total_laid_off,
        percentage_laid_off,
        date, 
        stage,
        country,
        funds_raised_millions) AS row_num
	FROM layoffs_staging
)

SELECT *
FROM duplicates
WHERE row_num > 1;

# to remove them 
# create another staging table
CREATE TABLE `layoffs_staging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# populate table `layoffs_staging_2`
INSERT INTO layoffs_staging_2
SELECT *,
    ROW_NUMBER() OVER(PARTITION BY 
		company,
        location,
        industry,
        total_laid_off,
        percentage_laid_off,
        date, 
        stage,
        country,
        funds_raised_millions) AS row_num
	FROM layoffs_staging;

# delete the duplicates
DELETE FROM layoffs_staging_2
WHERE row_num > 1;

# standardize data
# company column: extra space
UPDATE layoffs_staging_2
SET company = trim(company);

# industry column: standardizing value
UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypt%';

# country column: standardizing value
UPDATE layoffs_staging_2
SET country = trim(trailing '.' from country)
WHERE country LIKE 'united st%';

# remove/populate blanks and nulls
# fill blanks with null
UPDATE layoffs_staging_2
SET industry = NULL
WHERE industry = '';

# populate industry
UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	USING(company, location)
SET t2.industry = t1.industry
WHERE t2.industry IS NULL 
AND t1.industry IS NOT NULL;

# remove irrelevant columns
# remove useless columns
DELETE FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# remove row_num column created earlier
ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;

# bonus step
# change format
UPDATE layoffs_staging_2
SET date = str_to_date(date, '%m/%d/%Y');

# change datatype
ALTER TABLE layoffs_staging_2
MODIFY COLUMN date DATE;





