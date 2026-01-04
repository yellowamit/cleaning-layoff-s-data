-- exploratory data analysis
select max(total_laid_off) from layoffs_staging2;

select * 
from layoffs_staging2 
where percentage_laid_off=1
order by funds_raised_millions desc;
-- lets get over companies
select company, sum(total_laid_off) 
from layoffs_staging2
group by company
order by 2 desc;

-- get layoff date range
select min(`date`),max(`date`)
from layoffs_staging2;

-- which industry
select industry, sum(total_laid_off) 
from layoffs_staging2
group by industry
order by 2 desc;

-- which counttrys
select country, sum(total_laid_off) 
from layoffs_staging2
group by country
order by 2 desc;

-- by date
select `date`, sum(total_laid_off) 
from layoffs_staging2
group by `date`
order by 2 desc;
-- by year
select year(`date`), sum(total_laid_off) 
from layoffs_staging2
group by year(`date`)
order by 2 desc;




-- by month9
with rolling_total 
as
 (
select substring(`date`,1,7) as `Month` , sum(total_laid_off) as totallo
from layoffs_staging2
where substring(`date`,1,7)  is not null
group by `Month`
order by 1 asc
)
-- rollimg total 
select Month,totallo as total,  sum(totallo)over(order by Month
)as rt
 from rolling_total;
 
 -- per company laid off per year
 select company, year(`date`),sum(total_laid_off)
 from 
 layoffs_staging2
 group by company,year(`date`)
 order by 3 desc
 ;
 
with company_year(company,`year`,total_laid_off)
as(
select company, year(`date`),sum(total_laid_off)
 from 
 layoffs_staging2
 group by company,year(`date`)

 

)
,
company_rank as(
select *, 
dense_rank() 
over(
partition by `year` 
order by total_laid_off desc)
 as fools_rank
 from company_year
 where `year` is not null
 )
 select * from company_rank where fools_rank<=5;
