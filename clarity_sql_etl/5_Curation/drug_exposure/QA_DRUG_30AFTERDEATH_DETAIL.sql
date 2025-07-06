/*-------------------------------------------------------------------
----DRUG_30AFTERDEATH_DETAIL 
----Identifies drug exposures that occur more than 30 days after death
-------------------------------------------------------------------*/

WITH DRUG30AFTERDEATH_DETAIL AS (
    SELECT 
        'DRUG_EXPOSURE_START_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, DRUG_EXPOSURE_START_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM DRUG30AFTERDEATH_DETAIL;

/*--------------------------------------------------------------------
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the source table being validated
- QA_METRIC: Name of the quality check being performed
- METRIC_FIELD: Specific field being validated
- ERROR_TYPE: Category of error found
- CDT_ID: Drug exposure ID that failed validation

Logic:
1. Joins drug exposure and death tables on person_id
2. Identifies drug exposures that occur > 30 days after death date
3. Returns details about invalid records for QA reporting

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
--------------------------------------------------------------------*/