use ClimateAnalysis;


create schema staging;


CREATE TABLE ClimateAnalysis.staging.weather_stg AS
SELECT  * FROM ClimateAnalysis.integration.weather_raw;

CREATE TABLE ClimateAnalysis.staging.satellite_stg AS
SELECT * FROM ClimateAnalysis.integration.satellite_raw;

CREATE TABLE ClimateAnalysis.staging.emissions_stg AS
SELECT * FROM ClimateAnalysis.integration.emissions_raw;

