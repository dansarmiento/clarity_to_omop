--QA_OBSERVATION_VISITDATEDISPARITY_DETAIL
---------------------------------------------------------------------

{# --{{ config(materialized = 'view') }} #}

WITH VISITDATEDISPARITY_DETAIL AS (
SELECT 'OBSERVATION_DATE' AS METRIC_FIELD, 'VISIT_DATE_DISPARITY' AS QA_METRIC, 'WARNING' AS ERROR_TYPE, OBSERVATION_ID AS CDT_ID
FROM {{ref('OBSERVATION_RAW')}} AS O
LEFT JOIN {{ref('VISIT_OCCURRENCE_RAW')}} AS VO
	ON O.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
WHERE
	-- MUST HAVE POPULATED VISIT OCCURRENCE ID
	(O.VISIT_OCCURRENCE_ID IS NOT NULL
		AND O.VISIT_OCCURRENCE_ID <> 0
		AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
		AND VO.VISIT_OCCURRENCE_ID <> 0)
	AND (
		-- PROBLEM WITH OBSERVATION DATE
		(O.OBSERVATION_DATE < VO.VISIT_START_DATE
			OR O.OBSERVATION_DATE > VO.VISIT_END_DATE)
		OR
		-- PROBLEM WITH DATETIME
		(CAST(O.OBSERVATION_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
			OR CAST(O.OBSERVATION_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
		OR
		-- PROBLEM WITH THE DATETIME (EXTRACTING DATE FOR COMPARISON)
		(O.OBSERVATION_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
			OR O.OBSERVATION_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
		OR
		--PROBLEM WITH THE DATETIME
		(CAST(O.OBSERVATION_DATETIME AS DATE) < VO.VISIT_START_DATE
			OR CAST(O.OBSERVATION_DATETIME AS DATE) > VO.VISIT_END_DATE))
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
	,'OBSERVATION' AS STANDARD_DATA_TABLE
	, QA_METRIC AS QA_METRIC
	, METRIC_FIELD  AS METRIC_FIELD
	, ERROR_TYPE
	, CDT_ID
FROM VISITDATEDISPARITY_DETAIL

