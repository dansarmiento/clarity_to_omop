------ QA_VISIT_OCCURRENCE_ZEROCONCEPT_DETAIL
---------------------------------------------------------------------
WITH ZEROCONCEPT_DETAIL AS (
	SELECT 'VISIT_CONCEPT_ID' AS METRIC_FIELD,'ZERO CONCEPT' AS QA_METRIC,'WARNING' AS ERROR_TYPE
		,VISIT_OCCURRENCE_ID AS CDT_ID
	FROM {{ref('VISIT_OCCURRENCE_RAW')}} AS T1
	WHERE (VISIT_CONCEPT_ID = 0)
UNION ALL
	SELECT 'VISIT_TYPE_CONCEPT_ID' AS METRIC_FIELD,'ZERO CONCEPT' AS QA_METRIC,'WARNING' AS ERROR_TYPE
		,VISIT_OCCURRENCE_ID AS CDT_ID
	FROM {{ref('VISIT_OCCURRENCE_RAW')}} AS T1
	WHERE (VISIT_TYPE_CONCEPT_ID = 0)
-- UNION ALL
-- 	SELECT 'VISIT_SOURCE_CONCEPT_ID' AS METRIC_FIELD,'ZERO CONCEPT' AS QA_METRIC,'EXPECTED' AS ERROR_TYPE
-- 		,VISIT_OCCURRENCE_ID AS CDT_ID
-- 	FROM {{ref('VISIT_OCCURRENCE_RAW')}} AS T1
-- 	WHERE (VISIT_SOURCE_CONCEPT_ID = 0)
-- UNION ALL
-- 	SELECT 'ADMITTED_FROM_CONCEPT_ID' AS METRIC_FIELD,'ZERO CONCEPT' AS QA_METRIC,'EXPECTED' AS ERROR_TYPE
-- 		,VISIT_OCCURRENCE_ID AS CDT_ID
-- 	FROM {{ref('VISIT_OCCURRENCE_RAW')}} AS T1
-- 	WHERE (ADMITTED_FROM_CONCEPT_ID= 0)
-- UNION ALL
-- 	SELECT 'DISCHARGED_TO_CONCEPT_ID' AS METRIC_FIELD,'ZERO CONCEPT' AS QA_METRIC,'EXPECTED' AS ERROR_TYPE
-- 		,VISIT_OCCURRENCE_ID AS CDT_ID
-- 	FROM {{ref('VISIT_OCCURRENCE_RAW')}} AS T1
-- 	WHERE (DISCHARGED_TO_CONCEPT_ID= 0) AND DISCHARGED_TO_SOURCE_VALUE IS NULL
-- UNION ALL
-- 		SELECT 'DISCHARGED_TO_CONCEPT_ID' AS METRIC_FIELD,'ZERO CONCEPT' AS QA_METRIC,'WARNING' AS ERROR_TYPE
-- 		,VISIT_OCCURRENCE_ID AS CDT_ID
-- 	FROM {{ref('VISIT_OCCURRENCE_RAW')}} AS T1
-- 	WHERE (DISCHARGED_TO_CONCEPT_ID= 0) AND DISCHARGED_TO_SOURCE_VALUE IS NOT NULL
)

SELECT CAST (GETDATE() AS DATE) AS RUN_DATE
	,'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE
	, QA_METRIC AS QA_METRIC
	, METRIC_FIELD  AS METRIC_FIELD
	, ERROR_TYPE
	, CDT_ID
FROM ZEROCONCEPT_DETAIL
  WHERE ERROR_TYPE <>'EXPECTED'

