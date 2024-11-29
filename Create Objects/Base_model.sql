use ClimateAnalysis;

create schema base_model;

CREATE TABLE ClimateAnalysis.base_model.temperature_trend AS
SELECT 
    date,
    AVG(temperature) AS avg_temperature
FROM dimension.weather_fact
GROUP BY date;





CREATE TABLE ClimateAnalysis.base_model.co2_emission_summary AS
SELECT 
    country_id,
    COUNT(*) AS total_emissions,
    SUM(co2_emission) AS total_co2,
    MIN(date) AS first_record_date,
    MAX(date) AS last_record_date
FROM dimension.emissions_fact
GROUP BY country_id;



select * from temperature_trend;
