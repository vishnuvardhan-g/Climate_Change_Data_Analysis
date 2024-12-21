//Creating a Generic store procedure to moniter the data flow acorss the objects in pipelines
CREATE OR REPLACE PROCEDURE GET_TABLES_RECORD_COUNT(
    TABLE_NAMES ARRAY,
    SCHEMA_NAME STRING DEFAULT CURRENT_SCHEMA(),
    DATABASE_NAME STRING DEFAULT CURRENT_DATABASE()
)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
    try {
        // Create a temporary table for results
        const tempTable = "TEMP_TABLE_RECORD_COUNTS";
        snowflake.createStatement({
            sqlText: `CREATE OR REPLACE TEMP TABLE ${tempTable} (
                TABLE_NAME STRING,
                RECORD_COUNT NUMBER
            )`
        }).execute();

        // Loop through the array of table names
        for (let i = 0; i < TABLE_NAMES.length; i++) {
            const tableName = TABLE_NAMES[i];
            
            // Construct the SQL query
            const query = `SELECT '${tableName}' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT 
                           FROM ${DATABASE_NAME}.${SCHEMA_NAME}.${tableName}`;
            
            // Execute the query
            const stmt = snowflake.createStatement({ sqlText: query });
            const result = stmt.execute();
            
            // Fetch the count and insert it into the temporary table
            if (result.next()) {
                const recordCount = result.getColumnValue("RECORD_COUNT");
                snowflake.createStatement({
                    sqlText: `INSERT INTO ${tempTable} (TABLE_NAME, RECORD_COUNT)
                              VALUES ('${tableName}', ${recordCount})`
                }).execute();
            }
        }

        return `Record counts stored in temporary table: ${tempTable}`;
    } catch (err) {
        throw `Error: ${err.message}`;
    }
$$;

//calling the store procedure
call get_tables_record_count(['weather_fact','satellite_fact','emissions_fact'],'dimension','ClimateAnalysis');

//Extracting the stored results from temperory table
select * from temp_table_record_counts;
