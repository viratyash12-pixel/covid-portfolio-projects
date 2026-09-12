# covid-portfolio-projects
## COVID-19 Data Exploration (BigQuery SQL)

This project explores global COVID-19 case, death, and vaccination data using standard SQL (BigQuery dialect). It covers:

- **Case & death trends** — total cases and deaths by country/date, with death percentage (likelihood of dying if infected)
- **Population impact** — percentage of population infected, and countries ranked by highest infection rate relative to population
- **Mortality analysis** — highest total death counts by country and by continent
- **Vaccination tracking** — joining case data with vaccination data, using window functions (SUM() OVER PARTITION BY) to calculate a rolling count of people vaccinated per location, and a CTE to compute percent of population vaccinated

Techniques used: joins across tables, aggregate functions (MAX, SUM), SAFE_DIVIDE for null-safe division, window functions, CTEs, and temporary tables.
