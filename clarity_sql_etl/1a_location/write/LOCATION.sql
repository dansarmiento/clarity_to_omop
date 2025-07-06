/*******************************************************
 * Script: LOCATION Query
 * Description: Retrieves distinct location records excluding any records with fatal/invalid data errors
 * Tables:
 *    - CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW
 *    - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
 *******************************************************/

SELECT DISTINCT
    LOCATION_ID,              -- Unique identifier for location
    ADDRESS_1,                -- Primary street address
    ADDRESS_2,                -- Secondary street address 
    CITY,                     -- City name
    STATE,                    -- State abbreviation
    ZIP,                      -- ZIP/postal code
    COUNTY,                   -- County name
    LOCATION_SOURCE_VALUE     -- Original source value for the location

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS LOCATION

-- Join to exclude records with fatal/invalid data errors
LEFT JOIN (
    SELECT CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
    WHERE (STANDARD_DATA_TABLE = 'LOCATION')
        AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
) AS EXCLUSION_RECORDS
    ON LOCATION.LOCATION_ID = EXCLUSION_RECORDS.CDT_ID

-- Only include records that don't have fatal/invalid errors
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL)