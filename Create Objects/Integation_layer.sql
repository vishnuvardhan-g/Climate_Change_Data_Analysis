create database ClimateAnalysis;

use ClimateAnalysis;

create schema integration;

use ClimateAnalysis.integration;


CREATE TABLE ClimateAnalysis.integration.weather_raw (
    station_id STRING,
    date DATE,
    temperature FLOAT,
    precipitation FLOAT,
    wind_speed FLOAT
);

CREATE TABLE ClimateAnalysis.integration.satellite_raw (
    satellite_id STRING,
    date DATE,
    sea_level FLOAT,
    ice_melt_rate FLOAT
);

CREATE TABLE ClimateAnalysis.integration.emissions_raw (
    country_id STRING,
    date DATE,
    co2_emission FLOAT,
    deforestation_rate FLOAT
);
