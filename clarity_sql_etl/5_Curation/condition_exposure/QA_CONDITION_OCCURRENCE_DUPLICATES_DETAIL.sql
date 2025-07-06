/***************************************************************
 * QA_CONDITION_OCCURRENCE_DUPLICATES_DETAIL
 * 
 * Identifies duplicate records in CONDITION_OCCURRENCE_RAW table
 ***************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID,
           CONDITION_CONCEPT_ID,
           CONDITION_START_DATE,
           CONDITION_START_DATETIME, 
           CONDITION_END_DATE,
           CONDITION_END_DATETIME,
           CONDITION_TYPE_CONCEPT_ID,
           STOP_REASON,
           PROVIDER_ID,
           VISIT_OCCURRENCE_ID,
           CONDITION_SOURCE_VALUE,
           CONDITION_SOURCE_CONCEPT_ID,
           CONDITION_STATUS_SOURCE_VALUE,
           CONDITION_STATUS_CONCEPT_ID,
           src_VALUE_ID,
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
    WHERE T1.CONDITION_CONCEPT_ID <> 0
      AND T1.CONDITION_CONCEPT_ID IS NOT NULL
      AND T1.PERSON_ID <> 0 
      AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID,
             CONDITION_CONCEPT_ID,
             CONDITION_START_DATE,
             CONDITION_START_DATETIME,
             CONDITION_END_DATE,
             CONDITION_END_DATETIME,
             CONDITION_TYPE_CONCEPT_ID,
             STOP_REASON,
             PROVIDER_ID,
             VISIT_OCCURRENCE_ID,
             CONDITION_SOURCE_VALUE,
             CONDITION_SOURCE_CONCEPT_ID,
             CONDITION_STATUS_SOURCE_VALUE,
             CONDITION_STATUS_CONCEPT_ID,
             src_VALUE_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
       'DUPLICATE' AS QA_METRIC,
       'RECORDS' AS METRIC_FIELD,
       'FATAL' AS ERROR_TYPE,
       CO.CONDITION_OCCURRENCE_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CO 
    ON D.PERSON_ID = CO.PERSON_ID
    AND D.CONDITION_CONCEPT_ID = CO.CONDITION_CONCEPT_ID
    AND D.CONDITION_START_DATE = CO.CONDITION_START_DATE
    AND D.CONDITION_START_DATETIME = CO.CONDITION_START_DATETIME
    AND D.CONDITION_END_DATE = CO.CONDITION_END_DATE
    AND COALESCE(D.CONDITION_END_DATETIME,'1900-01-01') = COALESCE(CO.CONDITION_END_DATETIME,'1900-01-01')
    AND COALESCE(D.CONDITION_TYPE_CONCEPT_ID, 0) = COALESCE(CO.CONDITION_TYPE_CONCEPT_ID, 0)
    AND COALESCE(D.STOP_REASON, '0') = COALESCE(CO.STOP_REASON, '0')
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(CO.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(CO.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.CONDITION_SOURCE_VALUE, '0') = COALESCE(CO.CONDITION_SOURCE_VALUE, '0')
    AND COALESCE(D.CONDITION_SOURCE_CONCEPT_ID, 0) = COALESCE(CO.CONDITION_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.CONDITION_STATUS_SOURCE_VALUE, '0') = COALESCE(CO.CONDITION_STATUS_SOURCE_VALUE, '0')
    AND COALESCE(D.CONDITION_STATUS_CONCEPT_ID, 0) = COALESCE(CO.CONDITION_STATUS_CONCEPT_ID, 0)
    AND COALESCE(D.src_VALUE_ID, 0) = COALESCE(CO.src_VALUE_ID, 0);

/***************************************************************
 * Column Descriptions:
 * RUN_DATE - Date the QA check was executed
 * STANDARD_DATA_TABLE - Name of table being checked
 * QA_METRIC - Type of QA check (DUPLICATE)
 * METRIC_FIELD - Field being checked (RECORDS)
 * ERROR_TYPE - Severity of error (FATAL)
 * CONDITION_OCCURRENCE_ID - ID of duplicate condition record
 *
 * Logic:
 * 1. CTE finds groups of records with identical values across all fields
 * 2. Only includes valid condition concepts and person IDs
 * 3. Groups must have count > 1 to be considered duplicates
 * 4. Main query joins back to raw table to get condition IDs
 * 5. COALESCE handles NULL values in join conditions
 
LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 ***************************************************************/