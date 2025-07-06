---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_POS_DUP_DRUG_SOURCE_VALUE_DETAIL
-- Identifies potential duplicate drug exposure records based on matching values across multiple fields
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,DRUG_CONCEPT_ID 
        ,DRUG_EXPOSURE_START_DATETIME
        ,DRUG_EXPOSURE_END_DATETIME
        ,VERBATIM_END_DATE
        ,STOP_REASON
        ,REFILLS
        ,QUANTITY
        ,DAYS_SUPPLY
        ,SIG
        ,ROUTE_CONCEPT_ID
        ,LOT_NUMBER
        ,PROVIDER_ID
        ,VISIT_OCCURRENCE_ID
        ,ROUTE_SOURCE_VALUE
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE T1.DRUG_CONCEPT_ID != 0
        AND T1.DRUG_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID != 0 
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID
        ,DRUG_CONCEPT_ID
        ,DRUG_EXPOSURE_START_DATETIME
        ,DRUG_EXPOSURE_END_DATETIME
        ,VERBATIM_END_DATE
        ,STOP_REASON
        ,REFILLS
        ,QUANTITY
        ,DAYS_SUPPLY
        ,SIG
        ,ROUTE_CONCEPT_ID
        ,LOT_NUMBER
        ,PROVIDER_ID
        ,VISIT_OCCURRENCE_ID
        ,ROUTE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE
    ,'POSSIBLE_DUPLICATE' AS QA_METRIC
    ,'DRUG_SOURCE_VALUE' AS METRIC_FIELD
    ,'FOLLOW_UP' AS ERROR_TYPE
    ,DE.DRUG_EXPOSURE_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE 
    ON D.PERSON_ID = DE.PERSON_ID
    AND D.DRUG_CONCEPT_ID = DE.DRUG_CONCEPT_ID
    AND D.DRUG_EXPOSURE_START_DATETIME = DE.DRUG_EXPOSURE_START_DATETIME
    AND COALESCE(D.DRUG_EXPOSURE_END_DATETIME,'1900-01-01') = COALESCE(DE.DRUG_EXPOSURE_END_DATETIME,'1900-01-01')
    AND COALESCE(D.VERBATIM_END_DATE,'1900-01-01') = COALESCE(DE.VERBATIM_END_DATE,'1900-01-01')
    AND COALESCE(D.STOP_REASON, '0') = COALESCE(DE.STOP_REASON, '0')
    AND COALESCE(D.REFILLS, 0) = COALESCE(DE.REFILLS, 0)
    AND COALESCE(D.QUANTITY, 0) = COALESCE(DE.QUANTITY, 0)
    AND COALESCE(D.DAYS_SUPPLY, 0) = COALESCE(DE.DAYS_SUPPLY, 0)
    AND COALESCE(D.SIG, '0') = COALESCE(DE.SIG, '0')
    AND COALESCE(D.LOT_NUMBER, '0') = COALESCE(DE.LOT_NUMBER, '0')
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(DE.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(DE.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.ROUTE_SOURCE_VALUE, '0') = COALESCE(DE.ROUTE_SOURCE_VALUE, '0');

/*
Column Descriptions:
------------------
RUN_DATE: Date the QA check was executed
STANDARD_DATA_TABLE: Name of the table being checked (DRUG_EXPOSURE)
QA_METRIC: Type of quality check being performed (POSSIBLE_DUPLICATE)
METRIC_FIELD: Field being evaluated for duplicates (DRUG_SOURCE_VALUE)
ERROR_TYPE: Classification of the potential error (FOLLOW_UP)
DRUG_EXPOSURE_ID: Unique identifier for the drug exposure record

Logic:
------
1. CTE TMP_DUPES identifies groups of records that share the same values across multiple fields:
   - PERSON_ID
   - DRUG_CONCEPT_ID
   - DRUG_EXPOSURE_START_DATETIME
   - DRUG_EXPOSURE_END_DATETIME
   - Other drug exposure details
   
2. Only includes records where:
   - DRUG_CONCEPT_ID is valid (not 0 or NULL)
   - PERSON_ID is valid (not 0 or NULL)
   - Multiple records exist with identical values (COUNT > 1)

3. Main query joins back to DRUG_EXPOSURE_RAW to get DRUG_EXPOSURE_IDs for the duplicate records

4. COALESCE is used throughout to handle NULL values consistently in comparisons

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/