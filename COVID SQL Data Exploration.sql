/*
SQL - Data Exploration

Skills used: joins, aggregate functions, CTE's, creating views

Dataset: https://ourworldindata.org/covid-deaths
*/

#for data accuracy
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;


#select columns of interest
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


#total cases vs total deaths
#to explore the likelihood of dying if infected with COVID in a particular country
SELECT location, date, total_cases, total_deaths,
		(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location = 'United States'
AND continent IS NOT NULL
ORDER BY 1,2;


#total cases vs population
#to show what percentage of population infected w/ COVID
SELECT location, date, population, total_cases,
		(total_cases/population)*100
AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


#total cases vs population
#to show what percentage of population infected w/ COVID in USA
SELECT location, date, population, total_cases,
		(total_cases/population)*100
AS PercentPopulationInfected
FROM CovidDeaths
WHERE location = 'United States'
AND continent IS NOT NULL
ORDER BY 1,2;


#countries w/ highest infection rate compared to population
SELECT location, population, 
		MAX(total_cases) AS HighestInfectionCount,
        MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected
DESC;


#countries w/ highest death count per population
SELECT location, 
	MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount
DESC;


#exploring continents w/ highest death count per population
SELECT continent,
MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount
DESC;


#global death percentage
#to show percentage of total deaths compared to continent population
SELECT continent,
	SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 4
DESC;


#global death percentage
#to show percentage of total deaths compared to location population
SELECT location,
	SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 4
DESC;


#total population vs vaccinations
#to show what percentage of population recieved at least one COVID vaccine
SELECT 
    Cd.continent, 
    Cd.location, 
    Cd.date, 
    Cd.population, 
    Cv.new_vaccinations,
    SUM(Cv.new_vaccinations) OVER (PARTITION BY Cd.location
			ORDER BY Cd.location, Cd.date) AS RollingPeopleVaccinated,
    (SUM(Cv.new_vaccinations) OVER (PARTITION BY Cd.location
			ORDER BY Cd.location, Cd.date) / Cd.population) * 100 AS PercentageVaccinated
FROM 
    CovidDeaths AS Cd
JOIN 
    CovidVaccinations AS Cv
ON 
    Cd.location = Cv.location
    AND Cd.date = Cv.date
WHERE 
    Cd.continent IS NOT NULL
ORDER BY 
    Cd.location, Cd.date;
 
 
#calculations on partition by, using CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT 
        Cd.continent, 
        Cd.location, 
        Cd.date, 
        Cd.population, 
        Cv.new_vaccinations,
        SUM(Cv.new_vaccinations) OVER (PARTITION BY Cd.location ORDER BY Cd.location, Cd.date) AS RollingPeopleVaccinated
    FROM 
        CovidDeaths AS Cd
    JOIN 
        CovidVaccinations AS Cv
    ON 
        Cd.location = Cv.location
        AND Cd.date = Cv.date
    WHERE 
        Cd.continent IS NOT NULL
)
SELECT 
    *, 
    (RollingPeopleVaccinated/population)*100 AS PercentageVaccinated
FROM 
    PopvsVac;


#create view to store data, including rolling sum
CREATE VIEW PercentPopulationVaccinated AS
SELECT 
    Cd.continent, 
    Cd.location, 
    Cd.date, 
    Cd.population, 
    Cv.new_vaccinations, 
    SUM(Cv.new_vaccinations) OVER (PARTITION BY Cd.location) AS RollingPeopleVaccinated, 
    (SUM(Cv.new_vaccinations) OVER (PARTITION BY Cd.location) / Cd.population) * 100 AS PercentageVaccinated
FROM 
    CovidDeaths Cd
JOIN 
    CovidVaccinations Cv
	ON Cd.location = Cv.location
	AND Cd.date = Cv.date
WHERE 
    Cd.continent IS NOT NULL;


#checking views
SELECT *
FROM PercentPopulationVaccinated;