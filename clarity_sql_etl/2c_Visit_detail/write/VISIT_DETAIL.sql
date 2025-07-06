/*******************************************************
 * Query: VISIT_DETAIL Selection
 * Description: Retrieves distinct visit detail records excluding records with fatal or invalid data errors
 * Tables: VISIT_DETAIL_RAW, QA_ERR_DBT
 *******************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    VISIT_DETAIL_ID,                    -- Unique identifier for visit detail
    PERSON_ID,                          -- Foreign key to the PERSON table
    VISIT_DETAIL_CONCEPT_ID,            -- Concept ID for the type of visit
    VISIT_DETAIL_START_DATE,            -- Start date of the visit
    VISIT_DETAIL_START_DATETIME,        -- Start datetime of the visit
    VISIT_DETAIL_END_DATE,              -- End date of the visit
    VISIT_DETAIL_END_DATETIME,          -- End datetime of the visit
    VISIT_DETAIL_TYPE_CONCEPT_ID,       -- Concept ID for the type of visit detail record
    PROVIDER_ID,                        -- Foreign key to the PROVIDER table
    CARE_SITE_ID,                       -- Foreign key to the CARE_SITE table
    VISIT_DETAIL_SOURCE_VALUE,          -- Source value for the visit detail
    VISIT_DETAIL_SOURCE_CONCEPT_ID,     -- Source concept ID for the visit detail
    ADMITTED_FROM_SOURCE_VALUE,         -- Source value for admission source
    ADMITTED_FROM_CONCEPT_ID,           -- Concept ID for admission source
    DISCHARGED_TO_SOURCE_VALUE,         -- Source value for discharge destination
    DISCHARGED_TO_CONCEPT_ID,           -- Concept ID for discharge destination
    PRECEDING_VISIT_DETAIL_ID,          -- Foreign key to previous visit detail
    PARENT_VISIT_DETAIL_ID,             -- Foreign key to parent visit detail
    VISIT_OCCURRENCE_ID,                -- Foreign key to the VISIT_OCCURRENCE table

    -- Non-OMOP Fields
    ETL_MODULE,                         -- ETL module identifier
    phi_PAT_ID,                         -- Patient identifier (PHI)
    phi_MRN_CPI,                        -- Medical Record Number (PHI)
    phi_CSN_ID                          -- Contact Serial Number (PHI)

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS VISIT_DETAIL

-- Exclude records with fatal or invalid data errors
LEFT JOIN (
    SELECT CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
    WHERE (STANDARD_DATA_TABLE = 'VISIT_DETAIL')
    AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
) AS EXCLUSION_RECORDS
    ON VISIT_DETAIL.VISIT_DETAIL_ID = EXCLUSION_RECORDS.CDT_ID

WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL);