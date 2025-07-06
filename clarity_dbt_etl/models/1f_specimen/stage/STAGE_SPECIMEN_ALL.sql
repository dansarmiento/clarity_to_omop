--STAGE_SPECIMEN_ALL
{#-- {{ config(materialized = 'view', schema = 'OMOP_STAGE') }}#}

SELECT DISTINCT
	 PULL_SPECIMEN_ALL.PERSON_ID                                            AS PERSON_ID
    , COALESCE(SOURCE_TO_CONCEPT_MAP_SPECIMEN.TARGET_CONCEPT_ID, 0)         AS SPECIMEN_CONCEPT_ID
	, 0                                                                     AS SPECIMEN_TYPE_CONCEPT_ID
	, PULL_SPECIMEN_ALL.SPECIMEN_DATE                                       AS SPECIMEN_DATE
	, PULL_SPECIMEN_ALL.SPECIMEN_DATETIME                                   AS SPECIMEN_DATETIME
	, PULL_SPECIMEN_ALL.QUANTITY                                            AS QUANTITY -- MISSING FROM HSC_SPEC_INFO
	, NULL                                                                  AS UNIT_CONCEPT_ID -- MISSING FROM HSC_SPEC_INFO
	, COALESCE(SOURCE_TO_CONCEPT_MAP_ANATOMIC_SITE.TARGET_CONCEPT_ID, 0)    AS ANATOMIC_SITE_CONCEPT_ID
	, NULL                                                                  AS DISEASE_STATUS_CONCEPT_ID -- UNKNOWN
    , PULL_SPECIMEN_ALL.SPECIMEN_SOURCE_ID                                  AS SPECIMEN_SOURCE_ID
	, PULL_SPECIMEN_ALL.SPECIMEN_SOURCE_VALUE                               AS SPECIMEN_SOURCE_VALUE --Human readable Source Value use src_VALUE_ID below to link
	, NULL                                                                  AS UNIT_SOURCE_VALUE -- MISSING FROM HSC_SPEC_INFO
	, PULL_SPECIMEN_ALL.ANATOMIC_SITE_SOURCE_VALUE                          AS ANATOMIC_SITE_SOURCE_VALUE
	, NULL                                                                  AS DISEASE_STATUS_SOURCE_VALUE -- UNKNOWN

	-------- Non-OMOP Fields ------------
	,'SPECIMEN_ALL' 						                                AS STAGE_ETL_MODULE
    , PULL_PAT_ID                      		                                AS STAGE_PAT_ID
    , PULL_MRN_CPI                           	                            AS STAGE_MRN_CPI
	, PULL_SPECIMEN_TYPE_SOURCE_CODE									    AS STAGE_SPECIMEN_TYPE_SOURCE_CODE
    , PULL_SPECIMEN_ANATOMIC_SITE_SOURCE_CODE                               AS STAGE_SPECIMEN_ANATOMIC_SITE_SOURCE_CODE

FROM  {{ref('PULL_SPECIMEN_ALL')}} AS PULL_SPECIMEN_ALL

    ------- SOURCE TO CONCEPT MAPPINGS BEGIN---------
    LEFT JOIN   {{ ref('SOURCE_TO_CONCEPT_MAP_SPECIMEN')}} AS   SOURCE_TO_CONCEPT_MAP_SPECIMEN
        ON PULL_SPECIMEN_ALL.PULL_SPECIMEN_TYPE_SOURCE_CODE = SOURCE_TO_CONCEPT_MAP_SPECIMEN.SOURCE_CODE

    LEFT JOIN   {{ ref('SOURCE_TO_CONCEPT_MAP_ANATOMIC_SITE')}} AS  SOURCE_TO_CONCEPT_MAP_ANATOMIC_SITE
        ON PULL_SPECIMEN_ALL.PULL_SPECIMEN_ANATOMIC_SITE_SOURCE_CODE::VARCHAR = SOURCE_TO_CONCEPT_MAP_ANATOMIC_SITE.SOURCE_CODE
    ------- SOURCE TO CONCEPT MAPPINGS END ---------
