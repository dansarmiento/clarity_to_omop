/*********************************************************
 * Script Name: QA_SPECIMEN_DUPLICATES_DETAIL.sql
 * Author: Roger J Carlson - Corewell Health
 * Date: June 2025
 * 
 * Purpose: Identifies duplicate records in the SPECIMEN_RAW table
 *********************************************************/

WITH TMP_DUPES AS (
    SELECT    PERSON_ID
            , SPECIMEN_CONCEPT_ID
            , SPECIMEN_TYPE_CONCEPT_ID
            , SPECIMEN_DATE
            , SPECIMEN_DATETIME
            , QUANTITY
            , UNIT_CONCEPT_ID
            , ANATOMIC_SITE_CONCEPT_ID
            , DISEASE_STATUS_CONCEPT_ID
            , SPECIMEN_SOURCE_ID
            , SPECIMEN_SOURCE_VALUE
            , UNIT_SOURCE_VALUE
            , ANATOMIC_SITE_SOURCE_VALUE
            , DISEASE_STATUS_SOURCE_VALUE
            , COUNT(*) AS CNT

    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS T1
    GROUP BY  PERSON_ID
            , SPECIMEN_CONCEPT_ID
            , SPECIMEN_TYPE_CONCEPT_ID
            , SPECIMEN_DATE
            , SPECIMEN_DATETIME
            , QUANTITY
            , UNIT_CONCEPT_ID
            , ANATOMIC_SITE_CONCEPT_ID
            , DISEASE_STATUS_CONCEPT_ID
            , SPECIMEN_SOURCE_ID
            , SPECIMEN_SOURCE_VALUE
            , UNIT_SOURCE_VALUE
            , ANATOMIC_SITE_SOURCE_VALUE
            , DISEASE_STATUS_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    , 'SPECIMEN' AS STANDARD_DATA_TABLE
    , 'DUPLICATE' AS QA_METRIC
    , 'RECORDS'  AS METRIC_FIELD
    , 'FATAL' AS ERROR_TYPE
    , SP.SPECIMEN_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SP 
    ON D.PERSON_ID = SP.PERSON_ID
    AND D.SPECIMEN_CONCEPT_ID = SP.SPECIMEN_CONCEPT_ID
    AND COALESCE(D.SPECIMEN_TYPE_CONCEPT_ID, 0) = COALESCE(SP.SPECIMEN_TYPE_CONCEPT_ID, 0)
    AND D.SPECIMEN_DATE = SP.SPECIMEN_DATE
    AND COALESCE(D.SPECIMEN_DATETIME,'1900-01-01') = COALESCE(SP.SPECIMEN_DATETIME,'1900-01-01')
    AND COALESCE(D.QUANTITY, 0) = COALESCE(SP.QUANTITY, 0)
    AND COALESCE(D.UNIT_CONCEPT_ID, 0) = COALESCE(SP.UNIT_CONCEPT_ID, 0)
    AND COALESCE(D.ANATOMIC_SITE_CONCEPT_ID, 0) = COALESCE(SP.ANATOMIC_SITE_CONCEPT_ID, 0)
    AND COALESCE(D.DISEASE_STATUS_CONCEPT_ID, 0) = COALESCE(SP.DISEASE_STATUS_CONCEPT_ID, '0')
    AND COALESCE(D.SPECIMEN_SOURCE_ID, '0') = COALESCE(SP.SPECIMEN_SOURCE_ID, 0)
    AND COALESCE(D.SPECIMEN_SOURCE_VALUE, '0') = COALESCE(SP.SPECIMEN_SOURCE_VALUE, '0')
    AND COALESCE(D.UNIT_SOURCE_VALUE, '0') = COALESCE(SP.UNIT_SOURCE_VALUE, '0')
    AND COALESCE(D.ANATOMIC_SITE_SOURCE_VALUE, '0') = COALESCE(SP.ANATOMIC_SITE_SOURCE_VALUE, '0')
    AND COALESCE(D.DISEASE_STATUS_SOURCE_VALUE, '0') = COALESCE(SP.DISEASE_STATUS_SOURCE_VALUE, '0');

/*********************************************************
 * Column Descriptions:
 * RUN_DATE - Date the query was executed
 * STANDARD_DATA_TABLE - Name of the table being analyzed
 * QA_METRIC - Type of quality check being performed
 * METRIC_FIELD - Field being evaluated
 * ERROR_TYPE - Severity of the error
 * SPECIMEN_ID - Unique identifier for the specimen record
 *
 * Logic:
 * 1. Creates temporary table of duplicate records by grouping on all relevant fields
 * 2. Joins back to original table to get SPECIMEN_ID values
 * 3. Returns all duplicate records for further investigation
 *
 * Legal Warning:
 * This code is provided "AS IS" without warranty of any kind.
 * The entire risk as to the quality and performance of the code
 * is with you. Should the code prove defective, you assume
 * the cost of all necessary servicing, repair or correction.
 *********************************************************/