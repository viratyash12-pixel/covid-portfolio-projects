

-- -- selct data that we are going to be use
SELECT
  location,
  date,
  total_cases,
  population
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`
ORDER BY
  1,
  2;

-- looking at tatal cses vs total deaths
-- show likelihood of dying if you contract covid in your country
SELECT
  location,
  date,
  total_cases,
  total_deaths,
  SAFE_DIVIDE(total_deaths, total_cases) * 100 AS DeathPercentage
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`
ORDER BY
  1,
  2;

-- looking at total cases vs population
-- shows what percentage of population got covid
SELECT
  location,
  date,
  total_cases,
  population,
  SAFE_DIVIDE(total_cases, population) * 100 AS DeathPercentage
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`
ORDER BY
  1,
  2;

-- looking at countries with highest infection rate compared to population
SELECT
  location,
  MAX(population) AS max_population,
  MAX(total_cases) AS max_total_cases,
  (MAX(total_cases) / MAX(population)) * 100
    AS infection_percentage_of_population
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`
GROUP BY
  location, population
ORDER BY
  1, 2;

-- showing countries with highest death count per population
SELECT
  location,
  max(total_deaths) AS total_death_count
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`
GROUP BY
  location, population
ORDER BY
  total_death_count DESC;

-- select
-- *from
--  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`;

-- showing continents with the highest death count per population
-- Let's break things down by continent
SELECT
  continent,
  location,
  MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths`
WHERE
  continent IS NOT NULL
GROUP BY
  continent,
  location
ORDER BY
  total_death_count DESC;

-- looking at total population VS vaccination
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations
FROM
  `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths` AS dea
JOIN
  `covid-healthcare-project`.`covide_datasey_project`.`vaccination ` AS vac
  ON
    dea.iso_code = vac.iso_code
    AND dea.date = CAST(vac.date AS DATE)
ORDER BY
  dea.continent,
  dea.location,
  dea.date;

-- temp table
CREATE TEMPORARY TABLE PercentPopulationVaccinated(
  continent STRING,
  location STRING,
  date DATE,
  population NUMERIC,
  new_vaccinations NUMERIC,
  RollingPeopleVaccinated NUMERIC);

WITH
  PercentPopulationVaccinated AS (
    SELECT
      dea.continent,
      dea.location,
      dea.date,
      dea.population,
      vac.new_vaccinations,
      SUM(vac.new_vaccinations)
        OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
        AS RollingPeopleVaccinated
    FROM
      `covid-healthcare-project`.`covide_datasey_project`.`covid_deatths` AS dea
    JOIN
      `covid-healthcare-project`.`covide_datasey_project`.`vaccination ` AS vac
      ON
        dea.location = vac.location
        AND dea.date = CAST(vac.date AS DATE)
  )
SELECT
  *,
  (RollingPeopleVaccinated / population) * 100 AS PercentVaccinated
FROM
  `PercentPopulationVaccinated`;
