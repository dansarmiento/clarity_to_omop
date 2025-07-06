/**
 * ETL Query for Anesthesia Notes
 * 
 * This query transforms anesthesia notes data into the OMOP CDM Note table format.
 * It includes mappings for note class concepts and joins with provider and visit data.
 */

-- CTE for Note Class Mapping
WITH __dbt__cte__SOURCE_TO_CONCEPT_MAP_NOTE_CLASS AS (
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_NOTE_CLASS'
)

-- Main Note Selection Query
SELECT DISTINCT
    -- Required OMOP CDM Fields
    PULL_NOTE_ANES_ALL.PERSON_ID                                     AS PERSON_ID,
    NOTE_DATE                                                        AS NOTE_DATE,
    NOTE_DATETIME                                                    AS NOTE_DATETIME,
    32817                                                           AS NOTE_TYPE_CONCEPT_ID,  -- Standard note type
    COALESCE(SOURCE_TO_CONCEPT_MAP_NOTE_CLASS.TARGET_CONCEPT_ID, 0) AS NOTE_CLASS_CONCEPT_ID,
    NOTE_TITLE                                                      AS NOTE_TITLE,
    PULL_NOTE_ANES_ALL.NOTE_TEXT                                    AS NOTE_TEXT,
    32678                                                           AS ENCODING_CONCEPT_ID,   -- UTF-8
    4180186                                                         AS LANGUAGE_CONCEPT_ID,   -- English
    PROVIDER.PROVIDER_ID                                            AS PROVIDER_ID,
    VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID                            AS VISIT_OCCURRENCE_ID,
    NULL                                                            AS VISIT_DETAIL_ID,
    NOTE_SOURCE_VALUE                                               AS NOTE_SOURCE_VALUE,
    NULL                                                            AS NOTE_EVENT_ID,
    NULL                                                            AS NOTE_EVENT_FIELD_CONCEPT_ID,

    -- Custom Fields for Tracking
    'NOTE_ANES'                                                     AS ETL_MODULE,
    PULL_NOTE_ANES_ALL.PULL_IP_NOTE_TYPE_C                         AS STAGE_IP_NOTE_TYPE_C,
    PULL_NOTE_ANES_ALL.PULL_NOTE_ID                                AS STAGE_NOTE_ID,
    VISIT_OCCURRENCE.phi_PAT_ID                                     AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                                    AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                                     AS STAGE_CSN_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_ANES_ALL AS PULL_NOTE_ANES_ALL

    -- Join for Note Class Mapping
    LEFT JOIN __dbt__cte__SOURCE_TO_CONCEPT_MAP_NOTE_CLASS AS SOURCE_TO_CONCEPT_MAP_NOTE_CLASS
        ON PULL_IP_NOTE_TYPE_C || PULL_AMB_NOTE_YN = SOURCE_TO_CONCEPT_MAP_NOTE_CLASS.SOURCE_CODE

    -- Join for Visit Information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PULL_NOTE_ANES_ALL.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

    -- Join for Provider Information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_NOTE_ANES_ALL.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

WHERE NOTE_DATE IS NOT NULL