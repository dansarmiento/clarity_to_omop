---------------------------------------------------------------------
-- QA_LOCATION_DUPLICATES_DETAIL
-- Purpose: 
-- This query identifies duplicate location records in the LOCATION_RAW table.
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        LOCATION_ID,
        ADDRESS_1,
        ADDRESS_2,
        CITY,
        STATE,
        ZIP,
        COUNTY,
        LOCATION_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS T1
    GROUP BY  
        LOCATION_ID,
        ADDRESS_1,
        ADDRESS_2,
        CITY,
        STATE,
        ZIP,
        COUNTY,
        LOCATION_SOURCE_VALUE
    HAVING 
        COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'LOCATION' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    'FATAL' AS ERROR_TYPE,
    LO.LOCATION_ID
FROM 
    TMP_DUPES AS D
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS LO ON
        COALESCE(D.ADDRESS_1, '0') = COALESCE(LO.ADDRESS_1, '0')
        AND COALESCE(D.ADDRESS_2, '0') = COALESCE(LO.ADDRESS_2, '0')
        AND COALESCE(D.CITY, '0') = COALESCE(LO.CITY, '0')
        AND COALESCE(D.STATE, '0') = COALESCE(LO.STATE, '0')
        AND COALESCE(D.COUNTY, '0') = COALESCE(LO.COUNTY, '0')
        AND COALESCE(D.LOCATION_SOURCE_VALUE, '0') = COALESCE(LO.LOCATION_SOURCE_VALUE, '0')

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Indicates the table being analyzed ('LOCATION')
- QA_METRIC: Type of quality check being performed ('DUPLICATE')
- METRIC_FIELD: Specifies what is being checked ('RECORDS')
- ERROR_TYPE: Severity of the error ('FATAL')
- LOCATION_ID: Unique identifier for the location

Logic:
1. TMP_DUPES CTE:
   - Groups location records by all relevant fields
   - Identifies groups with more than one record (duplicates)

2. Main Query:
   - Joins back to LOCATION_RAW to get all duplicate records
   - Uses COALESCE to handle NULL values in comparison
   - Returns metadata about the QA check and the duplicate LOCATION_IDs

Note: 
- NULL values are treated as '0' in comparisons
- Duplicate check includes all address components and source values

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/