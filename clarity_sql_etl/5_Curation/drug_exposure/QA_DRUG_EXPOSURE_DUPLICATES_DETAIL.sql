---------------------------------------------------------------------
-- DRUG_EXPOSURE_DUPLICATES_DETAIL
-- Purpose: 
-- This query identifies duplicate records in the DRUG_EXPOSURE_RAW table based on all relevant fields.

-- Table Description:
-- - DRUG_EXPOSURE_RAW: Contains raw drug exposure data before deduplication
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATE,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATE,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        DRUG_TYPE_CONCEPT_ID,
        STOP_REASON,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        DRUG_SOURCE_CONCEPT_ID,
        ROUTE_SOURCE_VALUE,
        DOSE_UNIT_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE T1.DRUG_CONCEPT_ID != 0
        AND T1.DRUG_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID != 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATE,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATE,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        DRUG_TYPE_CONCEPT_ID,
        STOP_REASON,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        DRUG_SOURCE_CONCEPT_ID,
        ROUTE_SOURCE_VALUE,
        DOSE_UNIT_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    'FATAL' AS ERROR_TYPE,
    DE.DRUG_EXPOSURE_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE 
    ON D.PERSON_ID = DE.PERSON_ID
    AND D.DRUG_CONCEPT_ID = DE.DRUG_CONCEPT_ID
    AND D.DRUG_EXPOSURE_START_DATE = DE.DRUG_EXPOSURE_START_DATE
    AND D.DRUG_EXPOSURE_START_DATETIME = DE.DRUG_EXPOSURE_START_DATETIME
    AND D.DRUG_EXPOSURE_END_DATE = DE.DRUG_EXPOSURE_END_DATE
    AND COALESCE(D.DRUG_EXPOSURE_END_DATETIME,'1900-01-01') = COALESCE(DE.DRUG_EXPOSURE_END_DATETIME,'1900-01-01')
    AND COALESCE(D.VERBATIM_END_DATE,'1900-01-01') = COALESCE(DE.VERBATIM_END_DATE,'1900-01-01')
    AND COALESCE(D.DRUG_TYPE_CONCEPT_ID, 0) = COALESCE(DE.DRUG_TYPE_CONCEPT_ID, 0)
    AND COALESCE(D.STOP_REASON, '0') = COALESCE(DE.STOP_REASON, '0')
    AND COALESCE(D.REFILLS, 0) = COALESCE(DE.REFILLS, 0)
    AND COALESCE(D.QUANTITY, 0) = COALESCE(DE.QUANTITY, 0)
    AND COALESCE(D.DAYS_SUPPLY, 0) = COALESCE(DE.DAYS_SUPPLY, 0)
    AND COALESCE(D.SIG, '0') = COALESCE(DE.SIG, '0')
    AND COALESCE(D.ROUTE_CONCEPT_ID, 0) = COALESCE(DE.ROUTE_CONCEPT_ID, 0)
    AND COALESCE(D.LOT_NUMBER, '0') = COALESCE(DE.LOT_NUMBER, '0')
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(DE.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(DE.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.DRUG_SOURCE_VALUE, '0') = COALESCE(DE.DRUG_SOURCE_VALUE, '0')
    AND COALESCE(D.DRUG_SOURCE_CONCEPT_ID, 0) = COALESCE(DE.DRUG_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.ROUTE_SOURCE_VALUE, '0') = COALESCE(DE.ROUTE_SOURCE_VALUE, '0')
    AND COALESCE(D.DOSE_UNIT_SOURCE_VALUE, '0') = COALESCE(DE.DOSE_UNIT_SOURCE_VALUE, '0');

/*


Key Columns:
- DRUG_EXPOSURE_ID: Unique identifier for each drug exposure record
- PERSON_ID: Identifier for the patient
- DRUG_CONCEPT_ID: Identifier for the drug concept
- DRUG_EXPOSURE_START_DATE: Date when drug exposure started
- DRUG_EXPOSURE_END_DATE: Date when drug exposure ended

Logic:
1. TMP_DUPES CTE:
   - Groups records by all relevant fields
   - Identifies groups with more than one record (duplicates)
   - Excludes records with invalid DRUG_CONCEPT_ID or PERSON_ID

2. Main Query:
   - Joins back to original table to get DRUG_EXPOSURE_IDs
   - Uses COALESCE to handle NULL values in comparison
   - Returns metadata about the quality check including:
     * RUN_DATE: Current date
     * STANDARD_DATA_TABLE: Table being checked
     * QA_METRIC: Type of check (DUPLICATE)
     * METRIC_FIELD: Field being checked (RECORDS)
     * ERROR_TYPE: Severity of the error (FATAL)

Output:
Returns all duplicate DRUG_EXPOSURE_ID records that need to be addressed

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/