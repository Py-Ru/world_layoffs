# World Layoffs Data Cleaning Project

## Project Overview
This project involves cleaning a dataset containing information about layoffs across various companies. The goal is to standardize and clean the data, remove duplicates, handle missing values, and format the date column to make the data ready for analysis.

## Steps Performed
1. **Schema and Table Creation**: A new schema `world_layoffs` was created, and the `layoffs.csv` data was imported using MySQL's Data Import Wizard.
2. **Data Cleaning**:
   - Removed duplicates using `ROW_NUMBER()`.
   - Standardized data (e.g., trimming extra spaces, standardizing industry and country names).
   - Filled missing values in relevant columns.
   - Removed irrelevant columns (e.g., rows where all key values were NULL).
   - Converted the `date` column to a `DATE` type.
3. **Staging**: All operations were performed on a staging table for safety, allowing rollback if needed.

## How to Use
1. Clone this repository.
2. Run the `world_layoffs.sql` script in MySQL Workbench or any MySQL client.

## Data Source
- [Layoffs Data](link_to_source) (https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv).

## Improvements/Future Work
- Potential improvement includes performing exploratory data analysis (EDA) using SQL to uncover insights from the cleaned dataset.
