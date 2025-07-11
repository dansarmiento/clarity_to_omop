{#-- {{ config(materialized = 'view', schema = 'OMOP_STAGE') }}#}
--
--STAGE_VISIT_OCCURRENCE_HSP
SELECT DISTINCT
	 PULL_VISIT_OCCURRENCE_HSP.PERSON_ID 								AS PERSON_ID
	, COALESCE(SOURCE_TO_CONCEPT_MAP_VISIT.TARGET_CONCEPT_ID, 0) 		AS VISIT_CONCEPT_ID
	, PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE 						AS VISIT_START_DATE
	, PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATETIME 					AS VISIT_START_DATETIME
	, PULL_VISIT_OCCURRENCE_HSP.VISIT_END_DATE 							AS VISIT_END_DATE
	, PULL_VISIT_OCCURRENCE_HSP.VISIT_END_DATETIME 						AS VISIT_END_DATETIME
	, 32817 															AS VISIT_TYPE_CONCEPT_ID
	, PROVIDER.PROVIDER_ID   											AS PROVIDER_ID
	, CARE_SITE.CARE_SITE_ID 											AS CARE_SITE_ID
	, PULL_VISIT_OCCURRENCE_HSP.VISIT_SOURCE_VALUE 						AS VISIT_SOURCE_VALUE
	, NULL															 		AS VISIT_SOURCE_CONCEPT_ID
	, COALESCE(SOURCE_TO_CONCEPT_MAP_ADMIT.TARGET_CONCEPT_ID, 0) 		AS ADMITTED_FROM_CONCEPT_ID
	, PULL_VISIT_OCCURRENCE_HSP.ADMITTED_FROM_SOURCE_VALUE 				AS ADMITTED_FROM_SOURCE_VALUE
	, COALESCE(SOURCE_TO_CONCEPT_MAP_DISCHARGE.TARGET_CONCEPT_ID, 0) 	AS DISCHARGED_TO_CONCEPT_ID
	, PULL_VISIT_OCCURRENCE_HSP.DISCHARGED_TO_SOURCE_VALUE 				AS DISCHARGED_TO_SOURCE_VALUE
	, NULL 																AS PRECEDING_VISIT_OCCURRENCE_ID
	-------- Non-OMOP Fields ------------
	, 'STAGE_VISIT_OCCURRENCE_HSP' 										AS ETL_MODULE
	, PULL_VISIT_OCCURRENCE_HSP.PULL_PAT_ID                      		AS STAGE_PAT_ID
    , PULL_VISIT_OCCURRENCE_HSP.PULL_MRN_CPI                           	AS STAGE_MRN_CPI
	, PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID								AS STAGE_CSN_ID

FROM  {{ref('PULL_VISIT_OCCURRENCE_HSP')}} AS PULL_VISIT_OCCURRENCE_HSP

LEFT JOIN  {{ref('PROVIDER_RAW')}} AS PROVIDER ON
	PULL_VISIT_OCCURRENCE_HSP.PULL_PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

LEFT JOIN  {{ref('CARE_SITE_RAW')}} AS CARE_SITE
	ON PULL_VISIT_OCCURRENCE_HSP.PULL_CARE_SITE_ID = CARE_SITE.CARE_SITE_ID

INNER JOIN   {{ ref('SOURCE_TO_CONCEPT_MAP_VISIT')}} AS   SOURCE_TO_CONCEPT_MAP_VISIT
	ON PULL_VISIT_OCCURRENCE_HSP.PULL_VISIT_SOURCE_CODE = SOURCE_TO_CONCEPT_MAP_VISIT.SOURCE_CODE

LEFT JOIN   {{ ref('SOURCE_TO_CONCEPT_MAP_ADMIT')}} AS   SOURCE_TO_CONCEPT_MAP_ADMIT
	ON PULL_VISIT_OCCURRENCE_HSP.PULL_ADMIT_SOURCE_CODE = SOURCE_TO_CONCEPT_MAP_ADMIT.SOURCE_CODE

LEFT JOIN   {{ ref('SOURCE_TO_CONCEPT_MAP_DISCHARGE')}} AS  SOURCE_TO_CONCEPT_MAP_DISCHARGE
	ON PULL_VISIT_OCCURRENCE_HSP.PULL_DISCHARGE_SOURCE_CODE = SOURCE_TO_CONCEPT_MAP_DISCHARGE.SOURCE_CODE

LEFT JOIN --VISIT DATE CANNOT BE >30 DAYS AFTER DEATH_DATE
	 {{ref('DEATH_RAW')}} AS DEATH
	ON  PULL_VISIT_OCCURRENCE_HSP.PERSON_ID = DEATH.PERSON_ID

WHERE VISIT_END_DATETIME IS NOT NULL
	AND VISIT_START_DATETIME IS NOT NULL
	AND -- FUTURE VISITS REMOVED
	VISIT_START_DATETIME < COALESCE(DATEADD(DAY, 30, DEATH_DATE), GETDATE())

