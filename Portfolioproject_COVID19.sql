SELECT *
FROM PortfolioProject ..CovidDeaths$
where continent is not null
ORDER BY 3,4

SELECT *
FROM PortfolioProject ..CovidVaccinations$
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject ..CovidDeaths$
order by 1,2

-- 1. total cases vs totaldeaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject ..CovidDeaths$
where location like '%India%'
order by 1,2

-- 2.Totalcases vs population
SELECT location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject ..CovidDeaths$
where location like '%India%'
order by 1,2

-- 3.countries which have highest infection rate compared to population
SELECT location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject ..CovidDeaths$
  --where location like '%India%'
Group by Location, Population
order by PercentPopulationInfected desc

-- 4.countries which have highest death count per population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject ..CovidDeaths$
  --where location like '%India%
where continent is not null
Group by Location, Population
order by TotalDeathCount desc

-- 5.BREAK DOWN THE DATA BY CONTINENTS
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject ..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc

-- 6.Global Numbers
SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
where continent is not null
GROUP BY date
order by 1,2

-- 7.Death percent across the world
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

-- 8.Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations , SUM(CONVERT(int,vac.new_vaccinations)) OVER
      (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	 -- , (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ as dea
Join PortfolioProject..CovidVaccinations$ as vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by  2, 3

--USE CTE
With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations , SUM(CONVERT(int,vac.new_vaccinations)) OVER
      (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	 -- , (RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths$ as dea
Join PortfolioProject..CovidVaccinations$ as vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
)
SELECT *
FROM PopvsVac