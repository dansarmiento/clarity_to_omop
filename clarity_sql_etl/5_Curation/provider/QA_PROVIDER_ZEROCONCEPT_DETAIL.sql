/*********************************************************
Script Name: QA_PROVIDER_ZEROCONCEPT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

/*********************************************************
Description: This script identifies zero concepts in the PROVIDER table
            for specialty and gender fields, excluding expected zeros.

Tables Used: CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW
*********************************************************/

WITH CTE_ZEROCONCEPT_DETAIL AS (
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE, 
        'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (SPECIALTY_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE, 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (GENDER_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*********************************************************
Column Descriptions:
- RUN_DATE: Date when the query was executed
- STANDARD_DATA_TABLE: Name of the source table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Severity level of the identified issue
- CDT_ID: Provider ID associated with the zero concept

Logic:
1. Creates CTE to identify zero concepts in SPECIALTY_CONCEPT_ID 
   and GENDER_CONCEPT_ID fields
2. Excludes known/expected zero concepts
3. Returns only WARNING level issues

Legal Warning:
This code is provided "AS IS" without warranty of any kind.
Use at your own risk. The author and organization assume no 
responsibility for any issues arising from its use.
*********************************************************/