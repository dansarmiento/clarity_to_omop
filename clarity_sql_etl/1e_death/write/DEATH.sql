/*******************************************************************************
* Query: Death Records Retrieval
* Description: Retrieves death records excluding invalid or fatal error entries
* Tables: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT
    -- OMOP Standard Fields
    PERSON_ID,                    -- Unique identifier for the person
    DEATH_DATE,                   -- Date of death
    DEATH_DATETIME,               -- Date and time of death
    DEATH_TYPE_CONCEPT_ID,        -- Type of death record
    CAUSE_CONCEPT_ID,            -- Concept ID for cause of death
    CAUSE_SOURCE_VALUE,          -- Original source value for cause of death
    CAUSE_SOURCE_CONCEPT_ID,     -- Source concept ID for cause of death
    
    -- Non-OMOP Fields
    ETL_MODULE,                  -- ETL module identifier
    phi_PAT_ID,                 -- Patient ID (PHI)
    phi_MRN_CPI                 -- Medical Record Number (PHI)

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS DEATH
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = 'DEATH')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON DEATH.PERSON_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL)  -- Exclude records with fatal or invalid data errors