--
--STAGE_DRUG_EXPOSURE_ANES_RXNORM
{#-- {{ config(materialized = 'view', schema = 'OMOP_STAGE') }}#}
SELECT DISTINCT
--	CDM.SEQ_DRUG_EXPOSURE.NEXTVAL AS DRUG_EXPOSURE_ID
	 PULL_DRUG_EXPOSURE_ANES_RXNORM.PERSON_ID						AS PERSON_ID
	,T_DRUG_CONCEPT.DRUG_CONCEPT_ID									AS DRUG_CONCEPT_ID
	,DRUG_EXPOSURE_START_DATE 										AS DRUG_EXPOSURE_START_DATE
	,DRUG_EXPOSURE_START_DATETIME									AS DRUG_EXPOSURE_START_DATETIME
	,DRUG_EXPOSURE_END_DATE											AS DRUG_EXPOSURE_END_DATE
	,DRUG_EXPOSURE_END_DATETIME							 			AS DRUG_EXPOSURE_END_DATETIME
	,VERBATIM_END_DATE												AS VERBATIM_END_DATE
	,32817 															AS DRUG_TYPE_CONCEPT_ID -- EHR
	,STOP_REASON 													AS STOP_REASON
	,REFILLS 														AS REFILLS
	,QUANTITY														AS QUANTITY
	,DAYS_SUPPLY										 			AS DAYS_SUPPLY
	,SIG 															AS SIG
	,COALESCE(SOURCE_TO_CONCEPT_MAP_ROUTE.TARGET_CONCEPT_ID, 0) 	AS ROUTE_CONCEPT_ID
	,NULL 															AS LOT_NUMBER
	,PROVIDER.PROVIDER_ID											AS PROVIDER_ID
	,VISIT_OCCURRENCE_ID 											AS VISIT_OCCURRENCE_ID
--    ,VISIT_DETAIL.VISIT_DETAIL_ID AS VISIT_DETAIL_ID
    ,0 																AS VISIT_DETAIL_ID
	,PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_MEDICATION_ID::VARCHAR
			||':'||PULL_MEDICATION_NAME								AS DRUG_SOURCE_VALUE
	,T_DRUG_SOURCE.CONCEPT_ID 										AS DRUG_SOURCE_CONCEPT_ID
	,PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_MED_ROUTE_C::VARCHAR
	    || ':' || PULL_ZC_ADMIN_ROUTE_NAME					 		AS ROUTE_SOURCE_VALUE
	,DOSE_UNIT_SOURCE_VALUE 										AS DOSE_UNIT_SOURCE_VALUE
	-------- Non-OMOP Fields ------------
	, 'DRUG_EXPOSURE_ANES_RXNORM' 									AS ETL_MODULE
	, VISIT_OCCURRENCE.phi_PAT_ID                      				AS STAGE_PAT_ID
    , VISIT_OCCURRENCE.phi_MRN_CPI                           		AS STAGE_MRN_CPI
	, VISIT_OCCURRENCE.phi_CSN_ID									AS STAGE_CSN_ID
	, PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_MEDICATION_ID				AS STAGE_MEDICATION_ID


FROM {{ref('PULL_DRUG_EXPOSURE_ANES_RXNORM')}} AS PULL_DRUG_EXPOSURE_ANES_RXNORM

INNER JOIN {{ref('VISIT_OCCURRENCE_RAW')}} AS VISIT_OCCURRENCE
	ON PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

LEFT JOIN {{ref('PROVIDER_RAW')}} AS PROVIDER
	ON PULL_DRUG_EXPOSURE_ANES_RXNORM.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

INNER JOIN {{ref('TOP_ANES_RXNORM')}} AS TOP_RXNORM
	ON PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_MEDICATION_ID = TOP_RXNORM.PULL_MEDICATION_ID

INNER JOIN {{ref('T_DRUG_SOURCE')}} AS T_DRUG_SOURCE
	ON TOP_RXNORM.CONCEPT_CODE = T_DRUG_SOURCE.CONCEPT_CODE

INNER JOIN {{ref('T_DRUG_CONCEPT')}} AS T_DRUG_CONCEPT
	ON T_DRUG_SOURCE.CONCEPT_ID = T_DRUG_CONCEPT.DRUG_CONCEPT_SOURCE_CONCEPT_ID

LEFT JOIN {{ ref('SOURCE_TO_CONCEPT_MAP_ROUTE')}} AS SOURCE_TO_CONCEPT_MAP_ROUTE
	ON PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_MED_ROUTE_C::VARCHAR  =  SOURCE_TO_CONCEPT_MAP_ROUTE.SOURCE_CODE::VARCHAR

INNER JOIN -- THIS REMOVES THE DUPLICATES
	(
	SELECT MIN(PULL_RXNORM_CODES_LINE) AS FIRSTLINE
		,TOP_RXNORM.PULL_MEDICATION_ID
		,MIN(CONCEPT_CODE) AS CONCEPT_CODE
		,CONCEPT_CLASS_ID
		,THEORDER
	FROM {{ref('TOP_ANES_RXNORM')}} AS TOP_RXNORM
	GROUP BY PULL_MEDICATION_ID
		,CONCEPT_CLASS_ID
		,THEORDER
	    QUALIFY ROW_NUMBER() OVER (PARTITION BY TOP_RXNORM.PULL_MEDICATION_ID ORDER BY THEORDER desc, FIRSTLINE) = 1
	) X
	ON X.CONCEPT_CODE = TOP_RXNORM.CONCEPT_CODE
		AND X.PULL_MEDICATION_ID = TOP_RXNORM.PULL_MEDICATION_ID
