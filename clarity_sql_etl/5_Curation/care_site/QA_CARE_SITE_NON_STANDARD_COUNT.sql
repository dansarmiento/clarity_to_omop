/*******************************************************************************
* Script Name: QA_CARE_SITE_NON_STANDARD_COUNT
* Description: This query identifies non-standard place of service concepts 
*              in the CARE_SITE_RAW table
* 
* Tables Used: 
*    - CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
*    - CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.CONCEPT_stg
*    - CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
*
* Created: [Date]
* Modified: [Date]
*******************************************************************************/

-- CTE to calculate non-standard concept counts
WITH CTE_NON_STANDARD_COUNT AS (
    SELECT 
        CAST(GETDATE() AS DATE) AS RUN_DATE,
        'CARE_SITE' AS STANDARD_DATA_TABLE,
        'NON-STANDARD' AS QA_METRIC,
        'PLACE_OF_SERVICE_CONCEPT_ID' AS METRIC_FIELD,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT,
        -- Get total count of records in raw table
        (SELECT COUNT(*) AS NUM_ROWS 
         FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW) AS TOTAL_RECORDS,
        -- Get total count of records in clean table
        (SELECT COUNT(*) AS NUM_ROWS 
         FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE) AS TOTAL_RECORDS_CLEAN
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.CONCEPT_stg AS C
        ON P.PLACE_OF_SERVICE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'PLACE OF SERVICE'
    WHERE PLACE_OF_SERVICE_CONCEPT_ID <> 0 
    AND STANDARD_CONCEPT <> 'S'
)

-- Final result set
SELECT 
    RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    TOTAL_RECORDS,
    TOTAL_RECORDS_CLEAN
FROM CTE_NON_STANDARD_COUNT
GROUP BY 
    RUN_DATE,
    STANDARD_DATA_TABLE,
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE,
    TOTAL_RECORDS,
    TOTAL_RECORDS_CLEAN;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked (CARE_SITE)
* - QA_METRIC: Type of QA check being performed (NON-STANDARD)
* - METRIC_FIELD: Field being validated (PLACE_OF_SERVICE_CONCEPT_ID)
* - QA_ERRORS: Count of records that failed the QA check
* - ERROR_TYPE: Description of the error (INVALID DATA)
* - TOTAL_RECORDS: Total number of records in the raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* 1. The query identifies records where PLACE_OF_SERVICE_CONCEPT_ID is not 0
*    and the concept is not marked as standard ('S')
* 2. It joins CARE_SITE_RAW with CONCEPT_stg to validate place of service concepts
* 3. Counts are aggregated and compared against total record counts
* 4. Results show the proportion of non-standard concepts in the data

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/