use ClimateAnalysis;

create schema dimension;

CREATE TABLE ClimateAnalysis.dimension.weather_fact (
    station_id STRING,
    date DATE,
    temperature FLOAT,
    precipitation FLOAT,
    wind_speed FLOAT,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ClimateAnalysis.dimension.weather_station_dim (
    station_sk NUMBER AUTOINCREMENT,
    station_id STRING,
    location STRING,
    effective_start_date DATE,
    effective_end_date DATE,
    current_flag BOOLEAN DEFAULT TRUE,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ClimateAnalysis.dimension.satellite_fact (
    satellite_id STRING,
    date DATE,
    sea_level FLOAT,
    ice_melt_rate FLOAT,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ClimateAnalysis.dimension.emissions_fact (
    country_id STRING,
    date DATE,
    co2_emission FLOAT,
    deforestation_rate FLOAT,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

