---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_NOVISIT_DETAIL
-- Purpose:
-- This query identifies device exposure records that don't have associated visit records,
-- which is considered a fatal error in the data quality assessment.
---------------------------------------------------------------------

WITH CTE_NO_VISIT_DETAIL AS (
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE 
        ON DEVICE_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_NO_VISIT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Name of the source table being checked ('DEVICE_EXPOSURE')
- QA_METRIC: Type of quality check being performed ('NO VISIT')
- METRIC_FIELD: Field being evaluated ('DEVICE_CONCEPT_ID')
- ERROR_TYPE: Severity of the error ('FATAL')
- CDT_ID: Device exposure ID with the error

Logic:
1. CTE_NO_VISIT_DETAIL:
   - Performs a LEFT JOIN between DEVICE_EXPOSURE_RAW and VISIT_OCCURRENCE_RAW
   - Identifies records where there is no matching visit_occurrence_id
   
2. Main Query:
   - Retrieves all error records except those marked as 'EXPECTED'
   - Adds current run date to the results

Error Classification:
- FATAL: Indicates a serious data quality issue that needs immediate attention

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/