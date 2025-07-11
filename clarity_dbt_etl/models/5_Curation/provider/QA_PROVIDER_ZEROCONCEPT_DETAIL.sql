--QA_PROVIDER_ZEROCONCEPT_DETAIL
---------------------------------------------------------------------
WITH CTE_ZEROCONCEPT_DETAIL AS (
	SELECT 'PROVIDER' AS STANDARD_DATA_TABLE, 'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD, 'ZERO CONCEPT' AS QA_METRIC, 'WARNING' AS ERROR_TYPE, PROVIDER_ID AS CDT_ID
	FROM {{ref('PROVIDER_RAW')}} AS T1
	WHERE (SPECIALTY_CONCEPT_ID = 0 )

	UNION ALL

	SELECT 'PROVIDER' AS STANDARD_DATA_TABLE, 'GENDER_CONCEPT_ID' AS METRIC_FIELD, 'ZERO CONCEPT' AS QA_METRIC, 'WARNING' AS ERROR_TYPE, PROVIDER_ID AS CDT_ID
	FROM {{ref('PROVIDER_RAW')}} AS T1
	WHERE (GENDER_CONCEPT_ID = 0 )

	-- UNION ALL

	-- SELECT 'PROVIDER' AS STANDARD_DATA_TABLE, 'SPECIALTY_SOURCE_CONCEPT_ID' AS METRIC_FIELD, 'ZERO CONCEPT' AS QA_METRIC, 'EXPECTED' AS ERROR_TYPE, PROVIDER_ID AS CDT_ID
	-- FROM {{ref('PROVIDER_RAW')}} AS T1
	-- WHERE (SPECIALTY_SOURCE_CONCEPT_ID = 0 )

	-- UNION ALL

	-- SELECT 'PROVIDER' AS STANDARD_DATA_TABLE, 'GENDER_SOURCE_CONCEPT_ID' AS METRIC_FIELD, 'ZERO CONCEPT' AS QA_METRIC, 'EXPECTED' AS ERROR_TYPE, PROVIDER_ID AS CDT_ID
	-- FROM {{ref('PROVIDER_RAW')}} AS T1
	-- WHERE (GENDER_SOURCE_CONCEPT_ID = 0 )
	)

SELECT CAST(GETDATE() AS DATE ) AS RUN_DATE
	, STANDARD_DATA_TABLE
	, QA_METRIC AS QA_METRIC
	, METRIC_FIELD  AS METRIC_FIELD
	, ERROR_TYPE
	, CDT_ID
FROM CTE_ZEROCONCEPT_DETAIL
  WHERE ERROR_TYPE <>'EXPECTED'

