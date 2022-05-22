select* from dbo.covidDeaths
order by 3,4

Select * from dbo.covidVaccs
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population from dbo.covidDeaths
order by 1,2

--Looking at likelihood of dying of Covid if contracted in the U.S.

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from dbo.covidDeaths
where iso_code like'USA'
order by 1,2

--Total Cases vs Population

Select location, date, population, total_cases, (total_cases/population)*100 as ContractionPercentage
from dbo.covidDeaths
where iso_code like'USA'
order by 1,2


--COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

Select location, population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
from dbo.covidDeaths
group by location, population
order by PercentPopulationInfected desc

--Highest Death Count 

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
from dbo.covidDeaths
where continent is null
group by location
order by TotalDeathCount desc

--Global Numbers


Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from dbo.covidDeaths
--where iso_code like'USA'
where continent is not null
group by date
order by 1,2

--cte
with PopVsVac (continent, location, date, population, new_vaccinations, rollingtotal_vaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingtotal_vaccinations
from dbo.covidDeaths as dea
join dbo.covidVaccs as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
select *, (rollingtotal_vaccinations/population)*100 as percent_pop_vaccinated from PopVsVac


--CREATING VIEWS FOR LATER VISUALIZATIONS

CREATE VIEW percent_pop_vaccinated AS
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingtotal_vaccinations
from dbo.covidDeaths as dea
join dbo.covidVaccs as vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3