use portfolioProject

--SELECT * FROM CovidDeaths$;
--SELECT * FROM CovidVaccinations$;


--SELECT DATA TO BE USED
select location, date,total_cases,new_cases,total_deaths, population from CovidDeaths$ order by 1,2

--looking at total cases versus total deaths USING NIGERIA as case study
select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths$ where location='Nigeria'
order by 1,2

--looking at total cases versus the population shows the percentage that got infected
select location, total_cases,date, population, (total_cases/population)*100 as infectionrate
from CovidDeaths$ 
--where location='Nigeria'
order by 1,2

--which country had the most infection rate compared to population
select location, population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as percentpopulationinfected
from CovidDeaths$ 
group by location,population
order by percentpopulationinfected desc

--countries with highest death count per population
select  continent,location,max(cast(total_deaths as int)) as totalDeathcount
from CovidDeaths$ where continent is not null
group by location,continent
order by totalDeathcount desc

--total deathrate in africa
select  continent,location,max(cast(total_deaths as int)) as totalDeathcount 
from CovidDeaths$ where continent like 'Africa'
group by continent,location
order by totalDeathcount desc

--global numbers
select  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from CovidDeaths$ WHERE continent is not null
order by 1,2

--exploring covidvaccinations
select * from CovidVaccinations$ 

--joining coviddeaths and vaccinations
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int))over (Partition by dea.location order by dea.location, dea.date) as vaccinecount
from CovidVaccinations$ vac
join CovidDeaths$ dea
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null
order by 1,2,3


--creating view to store data
create view percentpopulationvaccianted as
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,sum(cast(vac.new_vaccinations as int))over (Partition by dea.location order by dea.location, dea.date) as vaccinecount
from CovidVaccinations$ vac
join CovidDeaths$ dea
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null

select * from percentpopulationvaccianted



