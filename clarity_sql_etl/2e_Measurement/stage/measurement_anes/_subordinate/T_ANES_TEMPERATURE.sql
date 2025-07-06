/*
Purpose: This query retrieves temperature measurements from anesthesia flowsheets
         and maps them to standardized concepts using the SOURCE_TO_CONCEPT_MAP table.

Tables Used:
- CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
- CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_MEASUREMENT_ANES_FLOWSHEET
*/

-- CTE to filter source-to-concept mappings for temperature measurements
WITH __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP AS (
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_FLWSHT_MEAS_TEMP'
)

-- Main query to retrieve temperature measurements
SELECT DISTINCT 
    PERSON_ID,                  -- Unique identifier for the patient
    PULL_CSN_ID,               -- Contact Serial Number ID
    MEASUREMENT_DATE,          -- Date of temperature measurement
    MEASUREMENT_DATETIME,      -- Date and time of temperature measurement
    VALUE_SOURCE_VALUE,        -- Original temperature value
    VALUE_AS_NUMBER,           -- Numerical temperature value
    RANGE_LOW,                 -- Lower bound of normal range
    RANGE_HIGH,                -- Upper bound of normal range
    PULL_FLO_MEAS_ID,         -- Flowsheet measurement ID
    PULL_FLO_MEAS_NAME,       -- Name of the flowsheet measurement
    PROVIDER_SOURCE_VALUE,     -- Provider who recorded the measurement
    UNIT_SOURCE_VALUE          -- Unit of measurement
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_MEASUREMENT_ANES_FLOWSHEET AS PULL_MEASUREMENT_ANES_FLOWSHEET
    INNER JOIN __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS
        ON PULL_FLO_MEAS_ID::VARCHAR = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS.SOURCE_CODE;