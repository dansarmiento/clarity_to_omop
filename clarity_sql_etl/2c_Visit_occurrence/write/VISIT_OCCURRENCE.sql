/*******************************************************************************
* Script: VISIT_OCCURRENCE Query
* Description: Retrieves distinct visit occurrence records excluding records with 
*              fatal or invalid data errors
* Tables: 
*   - VISIT_OCCURRENCE_RAW
*   - QA_ERR_DBT
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    VISIT_OCCURRENCE_ID,                  -- Unique identifier for each visit
    PERSON_ID,                           -- Foreign key to the PERSON table
    VISIT_CONCEPT_ID,                    -- Type of visit (e.g., inpatient, outpatient)
    VISIT_START_DATE,                    -- Start date of the visit
    VISIT_START_DATETIME,                -- Start date and time of the visit
    VISIT_END_DATE,                      -- End date of the visit
    VISIT_END_DATETIME,                  -- End date and time of the visit
    VISIT_TYPE_CONCEPT_ID,              -- Metadata about the visit record
    PROVIDER_ID,                         -- Foreign key to the PROVIDER table
    CARE_SITE_ID,                       -- Foreign key to the CARE_SITE table
    VISIT_SOURCE_VALUE,                 -- Source value for the visit
    VISIT_SOURCE_CONCEPT_ID,            -- Source concept for the visit
    ADMITTED_FROM_CONCEPT_ID,           -- Concept ID for admission source
    ADMITTED_FROM_SOURCE_VALUE,         -- Source value for admission source
    DISCHARGED_TO_CONCEPT_ID,           -- Concept ID for discharge destination
    DISCHARGED_TO_SOURCE_VALUE,         -- Source value for discharge destination
    PRECEDING_VISIT_OCCURRENCE_ID,      -- ID of the preceding visit if applicable

    -- Non-OMOP Fields
    ETL_MODULE,                         -- ETL module identifier
    phi_PAT_ID,                         -- Patient identifier (PHI)
    phi_MRN_CPI,                        -- Medical Record Number (PHI)
    phi_CSN_ID                          -- Contact Serial Number (PHI)

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE

    -- Exclude records with fatal or invalid data errors
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = 'VISIT_OCCURRENCE')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL);