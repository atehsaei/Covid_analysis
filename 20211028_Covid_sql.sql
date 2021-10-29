/****** Script for SelectTopNRows command from SSMS  ******/



/*This table was created separately by Stored procedure (PROC), the table is re-designed 
as variables were in varchar(50) data type, which could possibly hinder any further calculations */

use PortfolioProject
go

/*SELECT *
FROM [covid_vaccination]*/
--=======================================================
  -- short-listing the columns that we will be using
--=======================================================

  select location, date, total_cases, new_cases, total_deaths, population
  from [WRK_covid_death]
  order by 1,2
  --=======================================================
  -- Calculating mortality rate
--=========================================================

  select location, date, total_cases, new_cases, total_deaths, population,
   (total_deaths/nullif(total_cases,0))*100 as Deathpercentage
   from [WRK_covid_death]
   order by 1,2
    
  --=======================================================
  -- Calculating Total cases VS. Population
  --=======================================================
  select location, date, total_cases, new_cases, total_deaths, population,
   (total_cases/nullif(population,0))*100 as Covid_Contaminated
   from [WRK_covid_death]
   order by 1,2
    
  --=======================================================
  -- Highest Infection rate
  --=======================================================
  select location, max( total_cases) as Max_case, population,
   max((total_cases/nullif(population,0)))*100 as Population_contaminated
   from [WRK_covid_death]
   group by location, population
   order by Population_contaminated desc

     --=======================================================
     -- Highest Mortality per population
     --=======================================================

	 select location, max( total_deaths) as Max_death, population,
	 max((total_cases/nullif(population,0)))*100 as Death_per_Population
	 from [WRK_covid_death]
	 group by location, population
	 order by Death_per_Population desc

	 select location,  max( total_deaths) as Max_death
	 
	 from [WRK_covid_death]
	 group by location
	 order by Max_death desc

	 --=======================================================
     -- Worldwide statistics
     --=======================================================
	 select sum( new_cases) as Total_new_cases, sum(new_deaths) as Total_new_death,
	sum (new_deaths)/sum(nullif(new_cases,0))*100 as LatestMortality
	 from PortfolioProject..WRK_covid_death

	 --===========================================================================
     -- Left-join Death and Vaccine tables
	 -- Total population vs Total vaccination using Common Table Expressions (CTE)
     --===========================================================================


	 select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
	 sum(convert(float, vac.new_vaccinations)) over (partition by dth.location order by dth.date) as Cumulative_new_vax
	 from [WRK_covid_death] as dth
	 join [dbo].[covid_vaccination] as vac
	 on dth.location = vac.location 
	 and dth.date=vac.date
	where dth.continent not like ''   
	and vac.new_vaccinations not like ''   
	order by 2,3
	
	 --===========================================================================
	 -- Total population vs Total vaccination using Common Table Expressions (CTE)
     --===========================================================================
	with PopvsVac (continent, location, date, population,  new_vaccinations, Cumulative_new_vax)
	as 
	(
		select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
		sum(convert(float, vac.new_vaccinations))
		over (partition by dth.location order by dth.date) as Cumulative_new_vax
		from [WRK_covid_death] as dth
		join [dbo].[covid_vaccination] as vac
		on dth.location = vac.location 
		and dth.date=vac.date
	where dth.continent not like ''   
	and vac.new_vaccinations not like ''   
	--order by 2,3
	)
	select *, (Cumulative_new_vax  /  nullif(population,0))*100 as new_vax_per_pop
	from PopvsVac

--===========================================================================
-- #vaccinated_population, using Temporary table
--===========================================================================
drop table if exists #vaccinated_population
create table #vaccinated_population
(
continent nvarchar(100),
location nvarchar(100),
date datetime,
population float,
new_vaccinations float,
Cumulative_new_vax float
)
insert into #vaccinated_population
 select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
	 sum(convert(float, vac.new_vaccinations)) over (partition by dth.location order by dth.date) as Cumulative_new_vax
	 from [WRK_covid_death] as dth
	 join [dbo].[covid_vaccination] as vac
	 on dth.location = vac.location 
	 and dth.date=vac.date
	where dth.continent not like ''   
	and vac.new_vaccinations not like ''   
	order by 2,3
	select *, (Cumulative_new_vax  /  nullif(population,0))*100 as new_vax_per_pop
	from #vaccinated_population

--===========================================================================
-- Creating view
--===========================================================================
create view vaccinated_population as
select dth.continent, dth.location, dth.date, dth.population, vac.new_vaccinations,
	 sum(convert(float, vac.new_vaccinations)) over (partition by dth.location order by dth.date) as Cumulative_new_vax
	 from [WRK_covid_death] as dth
	 join [dbo].[covid_vaccination] as vac
	 on dth.location = vac.location  
	 and dth.date=vac.date
	where dth.continent not like ''   
	and vac.new_vaccinations not like ''   
	--order by 2,3
	
	select * from vaccinated_population