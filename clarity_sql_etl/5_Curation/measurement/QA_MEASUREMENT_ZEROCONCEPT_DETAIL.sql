---------------------------------------------------------------------
------ QA_MEASUREMENT_ZEROCONCEPT_DETAIL
-- PURPOSE:
-- This query identifies measurements where concept IDs are zero, which might
-- indicate missing or incorrect concept mappings in the OMOP data model.
---------------------------------------------------------------------

WITH ZEROCONCEPT_DETAIL AS (
    -- Check for zero concept IDs in MEASUREMENT_CONCEPT_ID
    SELECT 
        'MEASUREMENT_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (MEASUREMENT_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concept IDs in OPERATOR_CONCEPT_ID
    SELECT 
        'OPERATOR_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (OPERATOR_CONCEPT_ID = 0)
)

-- Final selection of QA results
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked (MEASUREMENT)
QA_METRIC: Type of quality check being performed (ZERO CONCEPT)
METRIC_FIELD: Specific field being checked for zero concepts
ERROR_TYPE: Severity of the issue (WARNING in this case)
CDT_ID: MEASUREMENT_ID from the source table

LOGIC:
------
1. The CTE 'ZEROCONCEPT_DETAIL' identifies records where either:
   - MEASUREMENT_CONCEPT_ID equals 0
   - OPERATOR_CONCEPT_ID equals 0

2. These checks are combined using UNION ALL

3. The final query:
   - Adds the current date
   - Labels the source table
   - Returns only non-'EXPECTED' errors
   - Provides detailed information about each zero concept occurrence


LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.

*/