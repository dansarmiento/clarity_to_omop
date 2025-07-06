/*********************************************************
Script Name: QA_PROVIDER_NULL_CONCEPT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

WITH CTE_NULLCONCEPT_DETAIL AS (
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE,
        'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (SPECIALTY_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE,
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (GENDER_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Quality assurance metric being checked
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error (WARNING or ERROR)
CDT_ID: Provider ID from the source table

LOGIC:
------
1. Creates a CTE to identify null values in SPECIALTY_CONCEPT_ID 
   and GENDER_CONCEPT_ID fields in the PROVIDER_RAW table
2. Each null value is flagged as a WARNING
3. Final select excludes any 'EXPECTED' error types
4. Results show only current date records with warnings

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code
remains with you. In no event shall the author be liable for any
damages whatsoever arising out of or in connection with the use
or performance of this code.
*********************************************************/