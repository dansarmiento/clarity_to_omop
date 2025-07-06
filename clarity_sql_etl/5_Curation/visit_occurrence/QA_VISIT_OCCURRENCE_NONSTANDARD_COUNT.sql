/*******************************************************************************
Script Name: QA_VISIT_OCCURRENCE_NONSTANDARD_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script performs quality assurance checks on the VISIT_OCCURRENCE
table by identifying non-standard concept IDs in various fields.

*******************************************************************************/
WITH NONSTANDARD_COUNT
AS (
	--VISIT_CONCEPT_ID-------------------------------------------
	SELECT 'VISIT_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE, COUNT(*) AS CNT
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON VO.VISIT_CONCEPT_ID = C.CONCEPT_ID AND upper(C.VOCABULARY_ID) =  'VISIT' AND upper(C.DOMAIN_ID) = 'VISIT'
	WHERE VISIT_CONCEPT_ID <> 0 AND STANDARD_CONCEPT <> 'S'

	UNION ALL

	--VISIT_TYPE_CONCEPT_ID-------------------------------------------
	SELECT 'VISIT_TYPE_CONCEPT_ID', 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE, COUNT(*) AS CNT
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON VO.VISIT_TYPE_CONCEPT_ID = C.CONCEPT_ID AND upper(C.VOCABULARY_ID) =  'VISIT TYPE' AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT'
	WHERE VISIT_TYPE_CONCEPT_ID <> 0 AND STANDARD_CONCEPT <> 'S'

	UNION ALL

	--VISIT_SOURCE_CONCEPT_ID-------------------------------------------
	SELECT 'VISIT_SOURCE_CONCEPT_ID', 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE, COUNT(*) AS CNT
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON VO.VISIT_SOURCE_CONCEPT_ID = C.CONCEPT_ID AND upper(C.VOCABULARY_ID) =  'VISIT' AND upper(C.DOMAIN_ID) = 'VISIT'
	WHERE VISIT_SOURCE_CONCEPT_ID <> 0 AND STANDARD_CONCEPT <> 'S'

	UNION ALL

	--ADMITTED_FROM_CONCEPT_ID-------------------------------------------
	SELECT 'ADMITTED_FROM_CONCEPT_ID', 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE, COUNT(*) AS CNT
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON VO.ADMITTED_FROM_CONCEPT_ID= C.CONCEPT_ID AND upper(C.VOCABULARY_ID) =  'CMS PLACE OF SERVICE'
	WHERE ADMITTED_FROM_CONCEPT_ID<> 0 AND STANDARD_CONCEPT <> 'S'

	UNION ALL

	--DISCHARGED_TO_CONCEPT_ID-------------------------------------------
	SELECT 'DISCHARGED_TO_CONCEPT_ID', 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE, COUNT(*) AS CNT
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON VO.DISCHARGED_TO_CONCEPT_ID= C.CONCEPT_ID AND upper(C.VOCABULARY_ID) =  'CMS PLACE OF SERVICE'
	WHERE DISCHARGED_TO_CONCEPT_ID<> 0 AND STANDARD_CONCEPT <> 'S'
	)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NONSTANDARD_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being evaluated
- QA_ERRORS: Count of records failing the QA check
- ERROR_TYPE: Description of the error found
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
1. Checks each concept ID field against the CONCEPT table
2. Identifies non-standard concepts (where STANDARD_CONCEPT <> 'S')
3. Counts occurrences of non-standard concepts
4. Aggregates results by metric field

Legal Warning: 
This code is provided "as is" without warranty of any kind, either express or 
implied. Use at your own risk. The author and Corewell Health are not liable 
for any damages arising from its use.
*******************************************************************************/