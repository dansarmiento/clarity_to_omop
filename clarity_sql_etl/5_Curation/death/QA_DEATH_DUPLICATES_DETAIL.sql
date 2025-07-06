/***************************************************************
 * Script: QA_DEATH_DUPLICATES_DETAIL
 * Purpose: Identifies duplicate death records in DEATH_RAW table
 ***************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,DEATH_DATE
        ,DEATH_DATETIME 
        ,DEATH_TYPE_CONCEPT_ID
        ,CAUSE_CONCEPT_ID
        ,CAUSE_SOURCE_VALUE
        ,CAUSE_SOURCE_CONCEPT_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    GROUP BY PERSON_ID
        ,DEATH_DATE
        ,DEATH_DATETIME
        ,DEATH_TYPE_CONCEPT_ID
        ,CAUSE_CONCEPT_ID
        ,CAUSE_SOURCE_VALUE
        ,CAUSE_SOURCE_CONCEPT_ID
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'DEATH' AS STANDARD_DATA_TABLE  
    ,'DUPLICATE' AS QA_METRIC
    ,'RECORDS' AS METRIC_FIELD
    ,'FATAL' AS ERROR_TYPE
    ,DE.PERSON_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS DE 
    ON D.DEATH_DATE = DE.DEATH_DATE
    AND COALESCE(D.DEATH_DATETIME,'1900-01-01') = COALESCE(DE.DEATH_DATETIME,'1900-01-01')
    AND COALESCE(D.DEATH_TYPE_CONCEPT_ID, 0) = COALESCE(DE.DEATH_TYPE_CONCEPT_ID, 0) 
    AND COALESCE(D.CAUSE_CONCEPT_ID, 0) = COALESCE(DE.CAUSE_CONCEPT_ID, 0)
    AND COALESCE(D.CAUSE_SOURCE_VALUE, '0') = COALESCE(DE.CAUSE_SOURCE_VALUE, '0')
    AND COALESCE(D.CAUSE_SOURCE_CONCEPT_ID, 0) = COALESCE(DE.CAUSE_SOURCE_CONCEPT_ID, 0)

/***************************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked (DEATH)
- QA_METRIC: Type of quality check (DUPLICATE)
- METRIC_FIELD: Field being checked (RECORDS) 
- ERROR_TYPE: Severity of error (FATAL)
- PERSON_ID: Unique identifier for person with duplicate death record

LOGIC:
1. TMP_DUPES CTE finds records that have identical values across all key fields
   with COUNT > 1 indicating duplicates
2. Main query joins back to DEATH_RAW to get full duplicate records
3. COALESCE handles NULL values in join conditions by substituting default values
4. Results show details of duplicate death records that need to be resolved

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
***************************************************************/