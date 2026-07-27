create database TraceIQ_DB;
USE TraceIQ_DB;
GO
--Verify Data Import
SELECT  *
from Sheet1$

SELECT COUNT(*) AS TotalRows
FROM Sheet1$;
--Data Quality check
SELECT
COUNT(*)-COUNT(facility_id) AS Missing_Facility_ID,
COUNT(*)-COUNT(facility_name) AS Missing_Facility_Name,
COUNT(*)-COUNT(source_type) AS Missing_Source_Type,
COUNT(*)-COUNT(emission_quantity) AS Missing_Emission
FROM Sheet1$;

SELECT facility_id,COUNT(*) AS DuplicateCount
FROM Sheet1$
GROUP BY facility_id
HAVING COUNT(*)>1;
-- Executive Summary Queries
SELECT SUM(emission_quantity) AS Total_Emissions
FROM Sheet1$;

SELECT COUNT(DISTINCT facility_id) AS Total_Facilities
FROM Sheet1$;

SELECT COUNT(DISTINCT iso3) AS Total_Countries
FROM Sheet1$;

--Business Analysis Queries
SELECT TOP 10
facility_name,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY facility_name
ORDER BY Total_Emission DESC;

SELECT
iso3,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY iso3
ORDER BY Total_Emission DESC;

SELECT
source_type,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY source_type
ORDER BY Total_Emission DESC;

SELECT
subsector,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY subsector
ORDER BY Total_Emission DESC;

SELECT TOP 10
immediate_source_owner,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY immediate_source_owner
ORDER BY Total_Emission DESC;

--Time Trend Analysis
SELECT
year,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY year
ORDER BY year;

SELECT
month,
SUM(emission_quantity) AS Total_Emission
FROM Sheet1$
GROUP BY month
ORDER BY month;

--Super Emitter Analysis
SELECT
known_super_emitter_flag,
COUNT(*) AS Facilities
FROM Sheet1$
GROUP BY known_super_emitter_flag;

SELECT
SUM(emission_quantity) AS SuperEmitterEmission
FROM Sheet1$
WHERE known_super_emitter_flag=1;

--Sustainability Strategy Analysis
SELECT
recommended_strategy_name,
COUNT(*) AS Frequency
FROM Sheet1$
GROUP BY recommended_strategy_name
ORDER BY Frequency DESC;

SELECT
recommended_strategy_name,
AVG(recommended_total_emissions_reduced_per_year) AS AvgReduction
FROM Sheet1$
GROUP BY recommended_strategy_name
ORDER BY AvgReduction DESC;

SELECT
recommended_strategy_name,
AVG(recommended_difficulty_score) AS AvgDifficulty
FROM Sheet1$
GROUP BY recommended_strategy_name
ORDER BY AvgDifficulty DESC;

--Emission Risk Score
SELECT
facility_name,
emission_quantity,

CASE
WHEN emission_quantity >= 1000 THEN 'High Risk'
WHEN emission_quantity >= 500 THEN 'Medium Risk'
ELSE 'Low Risk'
END AS Risk_Level

FROM Sheet1$;

SELECT
CASE
WHEN emission_quantity >= 1000 THEN 'High Risk'
WHEN emission_quantity >= 500 THEN 'Medium Risk'
ELSE 'Low Risk'
END AS Risk_Level,

COUNT(*) AS Facilities

FROM Sheet1$

GROUP BY

CASE
WHEN emission_quantity >= 1000 THEN 'High Risk'
WHEN emission_quantity >= 500 THEN 'Medium Risk'
ELSE 'Low Risk'
END;

--country ranking
SELECT

iso3,
SUM(emission_quantity) AS TotalEmission,

DENSE_RANK() OVER(
ORDER BY SUM(emission_quantity) DESC
) AS CountryRank

FROM Sheet1$

GROUP BY iso3;

-- Facility Performance Score
SELECT

facility_name,

SUM(emission_quantity) AS TotalEmission,

CASE

WHEN SUM(emission_quantity) >= 1000 THEN 'Critical'

WHEN SUM(emission_quantity) >= 500 THEN 'High'

WHEN SUM(emission_quantity) >= 100 THEN 'Medium'

ELSE 'Low'

END AS PerformanceScore

FROM Sheet1$

GROUP BY facility_name;

--Recommendation Engine
SELECT

facility_name,
recommended_strategy_name,
recommended_total_emissions_reduced_per_year

FROM Sheet1$

ORDER BY recommended_total_emissions_reduced_per_year DESC;

-- KPI Achievement
SELECT 
    SUM(emission_quantity) AS CurrentEmission,
    SUM(recommended_total_emissions_reduced_per_year) AS ExpectedEmission,
    ROUND(
        (SUM(recommended_total_emissions_reduced_per_year) * 100.0) /
        SUM(emission_quantity)
    , 2) AS ReductionPercent
FROM Sheet1$;

-- Advanced SQL(CTE)
WITH CountryEmission AS 
(
    SELECT 
        iso3,
        SUM(emission_quantity) AS TotalEmission
    FROM Sheet1$
    GROUP BY iso3
)
SELECT * 
FROM CountryEmission;