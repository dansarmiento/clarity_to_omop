--QA_DRUG_EXPOSURE_INGREDIENTCLASS_DETAIL
---------------------------------------------------------------------

{# --{{ config(materialized = 'view') }} #}

WITH INGREDIENTCLASS_DETAIL AS (
SELECT 'DRUG_CONCEPT_ID' AS METRIC_FIELD, 'INGREDIENT CLASS' AS QA_METRIC, 'WARNING' AS ERROR_TYPE, DRUG_EXPOSURE_ID AS CDT_ID

FROM {{ref('DRUG_EXPOSURE_RAW')}} AS DRUG_EXPOSURE
LEFT JOIN {{ source('OMOP','CONCEPT')}} AS CONCEPT
	ON DRUG_EXPOSURE.DRUG_CONCEPT_ID = CONCEPT.CONCEPT_ID
WHERE (UPPER(CONCEPT.CONCEPT_CLASS_ID) = 'INGREDIENT')
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
	,'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE
	, QA_METRIC AS QA_METRIC
	, METRIC_FIELD  AS METRIC_FIELD
	, ERROR_TYPE
	, CDT_ID
FROM INGREDIENTCLASS_DETAIL
  WHERE ERROR_TYPE <>'EXPECTED'
