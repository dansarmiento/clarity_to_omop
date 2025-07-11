/*********************************************************
Script Name: QA_OBSERVATION_NONSTANDARD_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies non-standard concept IDs in the OBSERVATION table
**********************************************************/
WITH NONSTANDARD_DETAIL
AS (
	SELECT 'OBSERVATION_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
		, OBSERVATION_ID AS CDT_ID
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON OB.OBSERVATION_CONCEPT_ID = C.CONCEPT_ID AND upper(C.DOMAIN_ID) = 'OBSERVATION'
	WHERE OBSERVATION_CONCEPT_ID <> 0 AND OBSERVATION_CONCEPT_ID IS NOT NULL AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

	UNION ALL

	SELECT 'OBSERVATION_TYPE_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
		, OBSERVATION_ID AS CDT_ID
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON OB.OBSERVATION_TYPE_CONCEPT_ID = C.CONCEPT_ID AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT' AND upper(C.VOCABULARY_ID) =  ('TYPE CONCEPT')
	WHERE OBSERVATION_TYPE_CONCEPT_ID <> 0 AND OBSERVATION_TYPE_CONCEPT_ID IS NOT NULL AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

	UNION ALL

	SELECT 'VALUE_AS_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
		, OBSERVATION_ID AS CDT_ID
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON OB.VALUE_AS_CONCEPT_ID = C.CONCEPT_ID
	WHERE VALUE_AS_CONCEPT_ID <> 0 AND VALUE_AS_CONCEPT_ID IS NOT NULL AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

	UNION ALL

	SELECT 'QUALIFIER_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
		, OBSERVATION_ID AS CDT_ID
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON OB.QUALIFIER_CONCEPT_ID = C.CONCEPT_ID AND upper(C.DOMAIN_ID) = 'OBSERVATION' AND upper(C.CONCEPT_CLASS_ID) =  ('QUALIFIER VALUE')
	WHERE QUALIFIER_CONCEPT_ID <> 0 AND QUALIFIER_CONCEPT_ID IS NOT NULL AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

	UNION ALL

	SELECT 'UNIT_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
		, OBSERVATION_ID AS CDT_ID
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON OB.UNIT_CONCEPT_ID = C.CONCEPT_ID AND upper(C.DOMAIN_ID) = 'UNIT'
	WHERE UNIT_CONCEPT_ID <> 0 AND UNIT_CONCEPT_ID IS NOT NULL AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

	UNION ALL

	SELECT 'OBSERVATION_SOURCE_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
		, OBSERVATION_ID AS CDT_ID
	FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB
	LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
		ON OB.OBSERVATION_SOURCE_CONCEPT_ID = C.CONCEPT_ID AND upper(C.DOMAIN_ID) = 'OBSERVATION'
	WHERE OBSERVATION_SOURCE_CONCEPT_ID <> 0 AND C.CONCEPT_ID IS NULL
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'OBSERVATION' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       ERROR_TYPE,
       CDT_ID
FROM NONSTANDARD_DETAIL
WHERE ERROR_TYPE <>'EXPECTED';

/*********************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Classification of the error found
- CDT_ID: Observation ID of the record with the error

LOGIC:
1. Checks multiple concept ID fields in the OBSERVATION table
2. Verifies if concepts are standard concepts (STANDARD_CONCEPT = 'S')
3. Confirms concepts exist in the correct domains
4. Returns records where non-standard concepts are used

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
*********************************************************/