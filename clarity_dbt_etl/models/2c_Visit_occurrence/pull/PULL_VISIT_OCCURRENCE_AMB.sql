
--PULL_VISIT_OCCURRENCE_AMB 
{{ config(materialized='table', schema = 'OMOP_PULL',
        cluster_by = ['PULL_CSN_ID']) }}

SELECT DISTINCT
-- ***STAGE ATTRIBUTES***
-- fields used for the Stage
    PATIENT_DRIVER.PERSON_ID::NUMBER(28,0)          AS PERSON_ID
    ,CAST(COALESCE(PAT_ENC.CHECKIN_TIME,
	    PAT_ENC.APPT_TIME,
	    PAT_ENC.CONTACT_DATE) AS DATE)              AS VISIT_START_DATE
    ,COALESCE(PAT_ENC.CHECKIN_TIME,
        PAT_ENC.APPT_TIME,
	    PAT_ENC.CONTACT_DATE)                       AS VISIT_START_DATETIME
    ,CASE
		WHEN COALESCE(CHECKOUT_TIME,
                COALESCE(PAT_ENC.CHECKIN_TIME,
                        PAT_ENC.APPT_TIME,
                        PAT_ENC.CONTACT_DATE)) > COALESCE(PAT_ENC.CHECKIN_TIME,
                                                         PAT_ENC.APPT_TIME,
                                                         PAT_ENC.CONTACT_DATE)
		THEN CAST(COALESCE(CHECKOUT_TIME,
		            COALESCE(PAT_ENC.CHECKIN_TIME,
		                    PAT_ENC.APPT_TIME,
		                    PAT_ENC.CONTACT_DATE)) AS DATE)
		ELSE CAST( COALESCE(PAT_ENC.CHECKIN_TIME,
		                    PAT_ENC.APPT_TIME,
		                    PAT_ENC.CONTACT_DATE) AS DATE)
	END 										       AS VISIT_END_DATE
    ,CASE
		WHEN COALESCE(CHECKOUT_TIME,
                COALESCE(PAT_ENC.CHECKIN_TIME,
                         PAT_ENC.APPT_TIME,
                         PAT_ENC.CONTACT_DATE)) > COALESCE(PAT_ENC.CHECKIN_TIME,
                                                                            PAT_ENC.APPT_TIME,
                                                                            PAT_ENC.CONTACT_DATE) 
        THEN COALESCE(CHECKOUT_TIME,
		        COALESCE(PAT_ENC.CHECKIN_TIME,
		                PAT_ENC.APPT_TIME,
		                PAT_ENC.CONTACT_DATE))
		ELSE COALESCE(PAT_ENC.CHECKIN_TIME,
		            PAT_ENC.APPT_TIME,
		            PAT_ENC.CONTACT_DATE)
	END                                                 AS VISIT_END_DATETIME
	,ZC_DISP_ENC_TYPE_NAME			                    AS VISIT_SOURCE_VALUE

-- ***ADDITIONAL ATTRIBUTES***
-- Non-OMOP fields used for the Stage
    ,PATIENT_DRIVER.EHR_PATIENT_ID                      AS PULL_PAT_ID
    ,PATIENT_DRIVER.MRN_CPI                             AS PULL_MRN_CPI
    ,PAT_ENC.PAT_ENC_CSN_ID                             AS PULL_CSN_ID
    ,PAT_ENC.PRIMARY_LOC_ID                             AS PULL_CARE_SITE_ID
    ,COALESCE(VISIT_PROVIDER.PROV_ID, PCP_PROVIDER.PROV_ID)  AS PULL_PROVIDER_SOURCE_VALUE
    ,PAT_ENC.ENC_TYPE_C                                 AS PULL_ENC_TYPE_C

-- ***PULL attributes***
-- field names pulled from the source for verification purposes. May be duplicated above.
/* 	,PATIENT_DRIVER.EHR_PATIENT_ID
    ,PAT_ENC.PAT_ID
    ,PAT_ENC.PAT_ENC_CSN_ID                             AS VISIT_SOURCE_VALUE
    ,PAT_ENC.ENC_TYPE_C
    ,ZC_DISP_ENC_TYPE_NAME                              AS ZC_DISP_ENC_TYPE_NAME
    ,PAT_ENC.CHECKIN_TIME
    ,PAT_ENC.APPT_TIME
    ,PAT_ENC.ENC_INSTANT
    ,PAT_ENC.CONTACT_DATE
    ,PAT_ENC.CHECKOUT_TIME
    ,PAT_ENC.ENC_CLOSE_TIME
    ,PAT_ENC.ACCOUNT_ID
    ,PAT_ENC.HSP_ACCOUNT_ID
    ,PAT_ENC.INPATIENT_DATA_ID
    ,PAT_ENC_2.IP_DOC_CONTACT_CSN
    ,PAT_OR_ADM_LINK.PAT_ENC_CSN_ID                     AS PAT_OR_ADM_LINK_CSN
    ,VISIT_PROVIDER.PROV_NAME                           AS VISIT_PROVIDER_NAME
    ,VISIT_PROVIDER.PROV_TYPE                           AS VISIT_PROVIDER_TYPE
    ,PCP_PROVIDER.PROV_NAME                             AS PCP_PROVIDER_NAME
    ,PCP_PROVIDER.PROV_TYPE                             AS PCP_PROVIDER_TYPE
    ,CLARITY_LOC.LOC_NAME
    ,PAT_ENC.CALCULATED_ENC_STAT_C
    ,ZC_CALCULATED_ENC_STAT_NAME                        AS CALCULATED_ENC_STAT_NAME
    ,PAT_ENC.APPT_STATUS_C
    ,ZC_APPT_STATUS_NAME                                AS APPT_STATUS_NAME */

FROM  {{ ref('PAT_ENC_stg')}} AS PAT_ENC

        LEFT JOIN  {{ ref('PAT_ENC_2_stg')}} AS PAT_ENC_2 --HOD_2
            ON PAT_ENC.PAT_ENC_CSN_ID = PAT_ENC_2.IP_DOC_CONTACT_CSN

        LEFT JOIN  {{ ref('PAT_OR_ADM_LINK_stg')}} AS PAT_OR_ADM_LINK
            ON PAT_ENC.PAT_ENC_CSN_ID = PAT_OR_ADM_LINK.PAT_ENC_CSN_ID

    LEFT JOIN  {{ ref('CLARITY_LOC_stg')}} AS CLARITY_LOC
        ON PAT_ENC.PRIMARY_LOC_ID = CLARITY_LOC.LOC_ID

    LEFT JOIN  {{ ref('CLARITY_SER_stg')}} AS VISIT_PROVIDER
        ON PAT_ENC.VISIT_PROV_ID = VISIT_PROVIDER.PROV_ID

    LEFT JOIN  {{ ref('CLARITY_SER_stg')}} AS PCP_PROVIDER
        ON PAT_ENC.PCP_PROV_ID = PCP_PROVIDER.PROV_ID

    LEFT JOIN  {{ ref('ZC_DISP_ENC_TYPE_stg')}} AS ZC_DISP_ENC_TYPE
        ON PAT_ENC.ENC_TYPE_C = ZC_DISP_ENC_TYPE.DISP_ENC_TYPE_C

    LEFT JOIN  {{ ref('ZC_CALCULATED_ENC_STAT_stg')}} AS ZC_CALCULATED_ENC_STAT
        ON PAT_ENC.CALCULATED_ENC_STAT_C = ZC_CALCULATED_ENC_STAT.CALCULATED_ENC_STAT_C

    LEFT JOIN  {{ ref('ZC_APPT_STATUS_stg')}} AS ZC_APPT_STATUS
        ON PAT_ENC.APPT_STATUS_C = ZC_APPT_STATUS.APPT_STATUS_C

-- AOU list of participants
    INNER JOIN   {{ref('PATIENT_DRIVER')}} AS PATIENT_DRIVER
        ON  PAT_ENC.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID

WHERE PAT_ENC.ENC_TYPE_C <> 3
	AND (
		PAT_ENC.CALCULATED_ENC_STAT_C = 2
		OR PAT_ENC.CALCULATED_ENC_STAT_C IS NULL
		)
	AND (
		PAT_ENC.APPT_STATUS_C = 2
		OR PAT_ENC.APPT_STATUS_C IS NULL
		)
    -- AND PAT_ENC.CALCULATED_ENC_STAT_C <> 3
	-- AND PAT_ENC.CALCULATED_ENC_STAT_C <> 1