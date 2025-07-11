------ QA_PROVIDER_NULL_CONCEPT_COUNT
---------------------------------------------------------------------
WITH CTE_NULLCONCEPT_COUNT AS (
	SELECT 'PROVIDER' AS STANDARD_DATA_TABLE
		,'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD
		,'NULL CONCEPT' AS QA_METRIC
		,'WARNING' AS ERROR_TYPE
		,COUNT(*) AS CNT
	FROM {{ref('PROVIDER_RAW')}} AS T1
	WHERE (SPECIALTY_CONCEPT_ID IS NULL )
	UNION ALL
	SELECT 'PROVIDER' AS STANDARD_DATA_TABLE
		,'GENDER_CONCEPT_ID' AS METRIC_FIELD
		,'NULL CONCEPT' AS QA_METRIC
		,'WARNING' AS ERROR_TYPE
		,COUNT(*) AS CNT
	FROM {{ref('PROVIDER_RAW')}} AS T1
	WHERE (GENDER_CONCEPT_ID IS NULL )
	-- UNION ALL
	-- SELECT 'PROVIDER' AS STANDARD_DATA_TABLE
	-- 	,'SPECIALTY_SOURCE_CONCEPT_ID' AS METRIC_FIELD
	-- 	,'NULL CONCEPT' AS QA_METRIC
	-- 	,'EXPECTED' AS ERROR_TYPE
	-- 	,COUNT(*) AS CNT
	-- FROM {{ref('PROVIDER_RAW')}} AS T1
	-- WHERE (SPECIALTY_SOURCE_CONCEPT_ID IS NULL )
	-- UNION ALL
	-- SELECT 'PROVIDER' AS STANDARD_DATA_TABLE
	-- 	,'GENDER_SOURCE_CONCEPT_ID' AS METRIC_FIELD
	-- 	,'NULL CONCEPT' AS QA_METRIC
	-- 	,'EXPECTED' AS ERROR_TYPE
	-- 	,COUNT(*) AS CNT
	-- FROM {{ref('PROVIDER_RAW')}} AS T1
	-- WHERE (GENDER_SOURCE_CONCEPT_ID IS NULL )
)

SELECT CAST( GETDATE() AS DATE) AS RUN_DATE
	, STANDARD_DATA_TABLE
	, QA_METRIC
	, METRIC_FIELD
	, COALESCE(SUM(CNT),0) AS QA_ERRORS
	, CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END   AS ERROR_TYPE
	, (SELECT COUNT(*) AS NUM_ROWS FROM {{ref('PROVIDER_RAW')}}) AS TOTAL_RECORDS
	, (SELECT COUNT(*) AS NUM_ROWS FROM {{ref('PROVIDER')}}) AS TOTAL_RECORDS_CLEAN
FROM CTE_NULLCONCEPT_COUNT
GROUP BY  STANDARD_DATA_TABLE, METRIC_FIELD, QA_METRIC, ERROR_TYPE

