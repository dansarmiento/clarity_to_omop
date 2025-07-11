--PULL_DEVICE_EXPOSURE_HOSP_LDA
{#-- {{ config(materialized = 'view', schema = 'OMOP_PULL') }}#}
SELECT

-- ***STAGE ATTRIBUTES***
-- OMOP Standard fields used for the Stage
	PULL_VISIT_OCCURRENCE_HSP.PERSON_ID					AS PERSON_ID
	,IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT :: DATE		AS DEVICE_EXPOSURE_START_DATE
	,IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT 				AS DEVICE_EXPOSURE_START_DATETIME
	,IP_LDA_NOADDSINGLE.REMOVAL_INSTANT::DATE 			AS DEVICE_EXPOSURE_END_DATE
	,IP_LDA_NOADDSINGLE.REMOVAL_INSTANT					AS DEVICE_EXPOSURE_END_DATETIME
	,NULL												AS UNIQUE_DEVICE_ID
	,NULL 												AS PRODUCTION_ID --NEW 5.4
	,NULL 												AS QUANTITY
	,PULL_PROVIDER_SOURCE_VALUE 						AS PROVIDER_SOURCE_VALUE
--    ,VISIT_DETAIL.VISIT_DETAIL_ID AS VISIT_DETAIL_ID
    ,0 													AS VISIT_DETAIL_ID
	,IP_LDA_NOADDSINGLE.FLO_MEAS_ID :: VARCHAR
		||':'|| IP_FLO_GP_DATA.FLO_MEAS_NAME			AS DEVICE_SOURCE_VALUE
  	,NULL 												AS UNIT_SOURCE_VALUE --NEW 5.4

-- ***ADDITIONAL ATTRIBUTES***
-- Non_OMOP fields used for the Stage
	,PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID				AS PULL_CSN_ID
	,IP_LDA_NOADDSINGLE.FLO_MEAS_ID::VARCHAR			AS PULL_FLO_MEAS_ID
	,IP_FLO_GP_DATA.FLO_MEAS_NAME						AS PULL_FLO_MEAS_NAME

-- ***SOURCE ATTRIBUTES***
	-- PULL_VISIT_OCCURRENCE_HSP.PERSON_ID
	-- ,PULL_VISIT_OCCURRENCE_HSP.EHR_PATIENT_ID
	-- ,IP_LDA_NOADDSINGLE.PAT_ID
	-- ,IP_LDA_NOADDSINGLE.IP_LDA_ID
	-- ,IP_LDA_NOADDSINGLE.PAT_ENC_CSN_ID
	-- ,IP_LDA_NOADDSINGLE.FLO_MEAS_ID
	-- ,IP_FLO_GP_DATA.FLO_MEAS_NAME
	-- ,IP_FLO_GP_DATA.DISP_NAME AS FLO_MEAS_DISP_NAME
	-- ,IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT
	-- ,IP_LDA_NOADDSINGLE.REMOVAL_INSTANT
	-- ,IP_LDA_NOADDSINGLE.DESCRIPTION
	-- ,IP_LDA_NOADDSINGLE.PROPERTIES_DISPLAY
	-- ,IP_LDA_NOADDSINGLE.SITE
	-- ,PULL_VISIT_OCCURRENCE_HSP.BILL_ATTEND_PROV_ID

FROM {{ref('PULL_VISIT_OCCURRENCE_HSP')}} AS PULL_VISIT_OCCURRENCE_HSP

    INNER JOIN {{ ref('IP_LDA_NOADDSINGLE_stg')}} AS IP_LDA_NOADDSINGLE
        ON ( PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = IP_LDA_NOADDSINGLE.PAT_ENC_CSN_ID)

    INNER JOIN {{ ref('IP_FLO_GP_DATA_stg')}} AS IP_FLO_GP_DATA
        ON IP_LDA_NOADDSINGLE.FLO_MEAS_ID = IP_FLO_GP_DATA.FLO_MEAS_ID

WHERE IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT IS NOT NULL
