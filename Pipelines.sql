use ClimateAnalysis;


COPY INTO staging.weather_stg
FROM @climate_stage/weather_data.csv
FILE_FORMAT = (TYPE = CSV);

COPY INTO staging.satellite_stg
FROM @climate_stage/satellite_data.csv
FILE_FORMAT = (TYPE = CSV);

COPY INTO staging.emissions_stg
FROM @climate_stage/emissions_data.csv
FILE_FORMAT = (TYPE = CSV);



MERGE INTO ClimateAnalysis.dimension.weather_station_dim AS target
USING ClimateAnalysis.staging.weather_stg AS source
ON target.station_id = source.station_id
WHEN MATCHED AND target.current_flag = TRUE AND (
    target.location <> source.location
    )
THEN
    UPDATE SET 
        target.current_flag = FALSE,
        target.effective_end_date = CURRENT_DATE
WHEN NOT MATCHED THEN
    INSERT (
        station_id,
        location,
        effective_start_date,
        effective_end_date,
        current_flag,
        load_date
    )
    VALUES (
        source.station_id,
        source.location,
        CURRENT_DATE,
        NULL,
        TRUE,
        CURRENT_TIMESTAMP
    );




    ---------------------------------


    MERGE INTO dimension.weather_fact AS target
USING staging.weather_stg AS source
ON target.station_id = source.station_id AND target.date = source.date
WHEN MATCHED THEN 
    UPDATE SET 
        target.temperature = source.temperature,
        target.precipitation = source.precipitation,
        target.wind_speed = source.wind_speed,
        target.load_date = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        station_id,
        date,
        temperature,
        precipitation,
        wind_speed,
        load_date
    )
    VALUES (
        source.station_id,
        source.date,
        source.temperature,
        source.precipitation,
        source.wind_speed,
        CURRENT_TIMESTAMP
    );


    

MERGE INTO dimensional.satellite_fact AS target
USING staging.satellite_stg AS source
ON target.satellite_id = source.satellite_id AND target.date = source.date
WHEN MATCHED THEN 
    UPDATE SET 
        target.sea_level = source.sea_level,
        target.ice_melt_rate = source.ice_melt_rate,
        target.load_date = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        satellite_id,
        date,
        sea_level,
        ice_melt_rate,
        load_date
    )
    VALUES (
        source.satellite_id,
        source.date,
        source.sea_level,
        source.ice_melt_rate,
        CURRENT_TIMESTAMP
    );

MERGE INTO dimensional.emissions_fact AS target
USING staging.emissions_stg AS source
ON target.country_id = source.country_id AND target.date = source.date
WHEN MATCHED THEN 
    UPDATE SET 
        target.co2_emission = source.co2_emission,
        target.deforestation_rate = source.deforestation_rate,
        target.load_date = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
    INSERT (
        country_id,
        date,
        co2_emission,
        deforestation_rate,
        load_date
    )
    VALUES (
        source.country_id,
        source.date,
        source.co2_emission,
        source.deforestation_rate,
        CURRENT_TIMESTAMP
    );

