---------------------------------------------------------------------
-- QA_MEASUREMENT_NOVISIT_DETAIL
-- Purpose:
-- This query identifies measurements that don't have an associated visit record in the OMOP database.
---------------------------------------------------------------------

WITH NOVISIT_DETAIL AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON MEASUREMENT.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NOVISIT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Always set to 'MEASUREMENT' to identify the source table
- QA_METRIC: Set to 'NO VISIT' for records without associated visits
- METRIC_FIELD: Identifies the field being checked ('VISIT_OCCURRENCE_ID')
- ERROR_TYPE: Set to 'WARNING' for these records
- CDT_ID: The MEASUREMENT_ID from the source record

Logic:
1. Creates a CTE (NOVISIT_DETAIL) that:
   - Joins MEASUREMENT_RAW with VISIT_OCCURRENCE_RAW
   - Identifies records where no matching visit exists
2. Main query:
   - Returns only records where ERROR_TYPE is not 'EXPECTED'
   - Adds metadata columns for tracking and identification

Use Case:
Quality assurance check to identify measurement records that should have, 
but are missing, associated visit records in the database.

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/