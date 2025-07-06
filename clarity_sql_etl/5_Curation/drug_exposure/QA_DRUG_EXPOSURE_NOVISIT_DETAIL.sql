---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_NOVISIT_DETAIL
-- Purpose:
-- This query identifies drug exposure records that don't have an associated visit record,
-- which might indicate data quality issues.
---------------------------------------------------------------------

WITH NOVISIT_DETAIL AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON DRUG_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NOVISIT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Table Descriptions:
- DRUG_EXPOSURE_RAW: Contains drug exposure records
- VISIT_OCCURRENCE_RAW: Contains visit records

Column Descriptions:
1. RUN_DATE: Current date when the query is executed
2. STANDARD_DATA_TABLE: Fixed value 'DRUG_EXPOSURE' indicating the source table
3. QA_METRIC: Type of quality check being performed ('NO VISIT')
4. METRIC_FIELD: The field being checked ('VISIT_OCCURRENCE_ID')
5. ERROR_TYPE: Severity of the issue ('WARNING')
6. CDT_ID: The DRUG_EXPOSURE_ID of the record with the issue

Logic:
1. Creates a CTE (NOVISIT_DETAIL) that:
   - Joins DRUG_EXPOSURE_RAW with VISIT_OCCURRENCE_RAW
   - Identifies records where there's no matching visit record
2. Final select filters out any 'EXPECTED' error types
3. Only returns records where drug exposures don't have associated visits



LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/