-- QA_PERSON_NULLCONCEPT_DETAIL
---------------------------------------------------------------------
WITH NULLCONCEPT_DETAIL AS (
	SELECT 'GENDER_CONCEPT_ID' AS METRIC_FIELD,'NULL CONCEPT' AS QA_METRIC,'FATAL' AS ERROR_TYPE
		,PERSON_ID AS CDT_ID
	FROM {{ref('PERSON_RAW')}} AS T1
	WHERE (GENDER_CONCEPT_ID IS NULL)
UNION ALL
	SELECT 'RACE_CONCEPT_ID' AS METRIC_FIELD,'NULL CONCEPT' AS QA_METRIC,'FATAL' AS ERROR_TYPE
		,PERSON_ID AS CDT_ID
	FROM {{ref('PERSON_RAW')}} AS T1
	WHERE (RACE_CONCEPT_ID IS NULL)
UNION ALL
	SELECT 'ETHNICITY_CONCEPT_ID' AS METRIC_FIELD,'NULL CONCEPT' AS QA_METRIC,'FATAL' AS ERROR_TYPE
		,PERSON_ID AS CDT_ID
	FROM {{ref('PERSON_RAW')}} AS T1
	WHERE (ETHNICITY_CONCEPT_ID IS NULL)
-- UNION ALL
-- 	SELECT 'GENDER_SOURCE_CONCEPT_ID' AS METRIC_FIELD,'NULL CONCEPT' AS QA_METRIC,'FATAL' AS ERROR_TYPE
-- 		,PERSON_ID AS CDT_ID
-- 	FROM {{ref('PERSON_RAW')}} AS T1
-- 	WHERE (GENDER_SOURCE_CONCEPT_ID IS NULL)
-- UNION ALL
-- 	SELECT 'RACE_SOURCE_CONCEPT_ID' AS METRIC_FIELD,'NULL CONCEPT' AS QA_METRIC,'FATAL' AS ERROR_TYPE
-- 		,PERSON_ID AS CDT_ID
-- 	FROM {{ref('PERSON_RAW')}} AS T1
-- 	WHERE (RACE_SOURCE_CONCEPT_ID IS NULL)
-- UNION ALL
-- 	SELECT 'ETHNICITY_SOURCE_CONCEPT_ID' AS METRIC_FIELD,'NULL CONCEPT' AS QA_METRIC,'FATAL' AS ERROR_TYPE
-- 		,PERSON_ID AS CDT_ID
-- 	FROM {{ref('PERSON_RAW')}} AS T1
-- 	WHERE (ETHNICITY_SOURCE_CONCEPT_ID IS NULL)
)

SELECT CAST( GETDATE() AS DATE) AS RUN_DATE
	,'PERSON' AS STANDARD_DATA_TABLE
	, QA_METRIC AS QA_METRIC
	, METRIC_FIELD  AS METRIC_FIELD
	, ERROR_TYPE
	, CDT_ID
FROM NULLCONCEPT_DETAIL
  WHERE ERROR_TYPE <>'EXPECTED'

