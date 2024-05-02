-- DATA CLEANING

select *
from layoffs;

-- TASKS
-- 1. Remove duplicates
-- 2. Standardize the Data
-- 3. Lookup Null values and blank values
-- 4. Remove any columns if redundant

#1 create a copy of the raw table.
create table layoffs_stages
like layoffs;

select *
from layoffs_stages;

insert layoffs_stages
select *
from layoffs;

#2 Remove Duplicates.

-- check duplicates

select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_stages;

with duplicate_cte as
(
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_stages
)
select *
from duplicate_cte
where row_num > 1;

-- Confirm duplicate

select *
from layoffs_stages
where company = 'Yahoo';

select *
from layoffs_stages
where company = 'Cazoo';

-- Delete Duplicates

CREATE TABLE `layoffs_stages2` (
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

select *
from layoffs_stages2;

insert into layoffs_stages2
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_stages;

select *
from layoffs_stages2
where row_num > 1;

delete
from layoffs_stages2
where row_num > 1;

CREATE TABLE `layoffs_stages3` (
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

insert into layoffs_stages3
select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) row_num
from layoffs_stages;

select *
from layoffs_stages3
where row_num > 1;

delete
from layoffs_stages3
where row_num > 1;

select *
from layoffs_stages3
order by 1;

#3 Standardize the data.

select company, trim(company)
from layoffs_stages3;

update layoffs_stages3
set company = trim(company);

select distinct country
from layoffs_stages3
order by 1;

update layoffs_stages3
set industry = 'Crypto'
where industry like 'crypto_%';

update layoffs_stages3
set country = 'United States'
where country like 'United States_';

# Change the date text to datetime format.
select `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs_stages3;

update layoffs_stages3
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_stages3
modify column `date` date;


-- 3. Lookup Null values and blank values

# populate the industry

select *
from layoffs_stages3
where industry is null
or industry = '';

select *
from layoffs_stages3
where company like 'Bally%';

select t1.industry, t2.industry
from layoffs_stages3 t1
join layoffs_stages3 t2
	on t1.company = t2.company
where t1.industry is null
and (t2.industry is not null or t2.industry != '');

update layoffs_stages3 t1
join layoffs_stages3 t2
	on t1.company = t2.company
set t1.industry = null
where t1.industry = ''
and t2.industry is not null;


update layoffs_stages3 t1
join layoffs_stages3 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select *
from layoffs_stages3
where total_laid_off is null 
and percentage_laid_off is null;

delete
from layoffs_stages3
where total_laid_off is null 
and percentage_laid_off is null;

alter table layoffs_stages3
drop column row_num;

SELECT *
FROM layoffs_stages3;