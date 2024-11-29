use ClimateAnalysis;

create schema dimensional_key_map;

CREATE TABLE ClimateAnalysis.dimensional_key_map.station_key_map (
    station_id STRING,
    station_sk NUMBER,
    load_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
