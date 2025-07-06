--PULL_PERSON_ALL
{#-- {{ config(materialized = 'view', schema = 'OMOP_PULL') }}#}

SELECT DISTINCT
-- ***STAGE ATTRIBUTES***
-- fields used for the Stage
    PATIENT_DRIVER.PERSON_ID                                    AS PERSON_ID
    , YEAR(PATIENT.BIRTH_DATE)                                  AS YEAR_OF_BIRTH
    , MONTH(PATIENT.BIRTH_DATE)                                 AS MONTH_OF_BIRTH
    , DAY(PATIENT.BIRTH_DATE)                                   AS DAY_OF_BIRTH
    , PATIENT.BIRTH_DATE										AS BIRTH_DATETIME
    , FIRST_ZC_PATIENT_RACE.PATIENT_RACE_C                      AS PATIENT_RACE_C
    , ZC_ETHNIC_GROUP.ETHNIC_GROUP_C                            AS ETHNIC_GROUP_C
    , PATIENT.CUR_PCP_PROV_ID                                   AS CUR_PCP_PROV_ID
    , PATIENT.CUR_PRIM_LOC_ID                                   AS CUR_PRIM_LOC_ID
    , PATIENT.SEX_C
    , LEFT(COALESCE(PATIENT.ADD_LINE_1, '')
                    || COALESCE(PATIENT.ADD_LINE_2, '')
                    || COALESCE(PATIENT.CITY, '')
                    || COALESCE(LEFT(ZC_STATE_ABBR, 2), '')
                    || COALESCE(PATIENT.ZIP, '')
                    || COALESCE(ZC_COUNTY.COUNTY_C, ''), 50)    AS LOCATION_SOURCE_VALUE
-- ***PULL attributes***
-- field names pulled from the source for verification purposes. May be duplicated above.
    , PATIENT_DRIVER.EHR_PATIENT_ID                             AS PULL_PAT_ID
    , PATIENT_DRIVER.MRN_CPI                                    AS PULL_MRN_CPI
    , ZC_SEX_NAME                                               AS ZC_SEX_NAME
    , ZC_PATIENT_RACE_NAME                                      AS ZC_PATIENT_RACE_NAME
    , ZC_ETHNIC_GROUP_NAME                                      AS ZC_ETHNIC_GROUP_NAME
    , PATIENT.ADD_LINE_1
	, PATIENT.ADD_LINE_2
	, PATIENT.CITY
	, ZC_STATE_ABBR
	, PATIENT.ZIP
	, ZC_COUNTY.COUNTY_C

FROM     {{ ref('PATIENT_stg')}} AS PATIENT

    LEFT JOIN {{ ref('PATIENT_RACE_stg')}} AS FIRST_PATIENT_RACE
            ON PATIENT.PAT_ID = FIRST_PATIENT_RACE.PAT_ID AND FIRST_PATIENT_RACE.LINE=1

	LEFT JOIN   {{ ref('ZC_PATIENT_RACE_stg')}}  AS FIRST_ZC_PATIENT_RACE
		ON FIRST_PATIENT_RACE.PATIENT_RACE_C = FIRST_ZC_PATIENT_RACE.PATIENT_RACE_C

	LEFT JOIN   {{ ref('ZC_ETHNIC_GROUP_stg')}}  AS ZC_ETHNIC_GROUP
		ON ZC_ETHNIC_GROUP.ETHNIC_GROUP_C = PATIENT.ETHNIC_GROUP_C

	INNER JOIN   {{ ref('ZC_SEX_stg')}}  AS ZC_SEX
		ON ZC_SEX.RCPT_MEM_SEX_C = PATIENT.SEX_C

	LEFT JOIN   {{ ref('ZC_STATE_stg')}} AS ZC_STATE
		ON PATIENT.STATE_C = ZC_STATE.STATE_C

	LEFT JOIN   {{ ref('ZC_COUNTY_stg')}} AS ZC_COUNTY
		ON PATIENT.COUNTY_C = ZC_COUNTY.COUNTY_C

    INNER JOIN {{ref('PATIENT_DRIVER')}} AS PATIENT_DRIVER
        ON PATIENT.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID
