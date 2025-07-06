/*******************************************************************************
* Query: OBSERVATION Data Retrieval
* Description: Retrieves observation data excluding records with fatal/invalid errors
* Tables: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    OBSERVATION_ID,                    -- Unique identifier for observation
    PERSON_ID,                        -- Reference to person
    OBSERVATION_CONCEPT_ID,           -- Concept ID for the observation
    OBSERVATION_DATE,                 -- Date of observation
    OBSERVATION_DATETIME,             -- Date and time of observation
    OBSERVATION_TYPE_CONCEPT_ID,      -- Type of observation
    VALUE_AS_NUMBER,                  -- Numeric value of observation
    VALUE_AS_STRING,                  -- String value of observation
    VALUE_AS_CONCEPT_ID,             -- Concept ID for the value
    UNIT_CONCEPT_ID,                 -- Concept ID for measurement unit
    QUALIFIER_CONCEPT_ID,            -- Concept ID for qualifier
    PROVIDER_ID,                     -- Reference to provider
    VISIT_OCCURRENCE_ID,             -- Reference to visit
    VISIT_DETAIL_ID,                 -- Reference to visit detail
    OBSERVATION_SOURCE_VALUE,         -- Human readable source value
    OBSERVATION_SOURCE_CONCEPT_ID,    -- Source concept ID
    UNIT_SOURCE_VALUE,               -- Original unit value
    QUALIFIER_SOURCE_VALUE,          -- Original qualifier value
    VALUE_SOURCE_VALUE,              -- Original value
    OBSERVATION_EVENT_ID,            -- Event ID
    OBS_EVENT_FIELD_CONCEPT_ID,      -- Event field concept ID

    -- Non-OMOP Fields
    etl_MODULE,                      -- ETL module identifier
    phi_PAT_ID,                      -- Patient identifier
    phi_MRN_CPI,                     -- Medical record number
    phi_CSN_ID,                      -- CSN identifier
    
    -- Source Reference Fields
    src_TABLE,                       -- Source table name
    src_FIELD,                       -- Source field name
    src_VALUE_ID                     -- Source value identifier

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION

-- Exclude records with fatal/invalid errors
LEFT JOIN (
    SELECT CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
    WHERE (STANDARD_DATA_TABLE = 'OBSERVATION')
    AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
) AS EXCLUSION_RECORDS
ON OBSERVATION.OBSERVATION_ID = EXCLUSION_RECORDS.CDT_ID

WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL);