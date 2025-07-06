/*******************************************************************************
* Query: Person Data Extraction
* Description: Retrieves person demographic information excluding records with 
*              fatal or invalid data errors
* Tables: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT
    -- Standard OMOP Person Fields
    PERSON_ID,                      -- Unique identifier for person
    GENDER_CONCEPT_ID,             -- Concept ID for gender
    YEAR_OF_BIRTH,                 -- Birth year
    MONTH_OF_BIRTH,                -- Birth month
    DAY_OF_BIRTH,                  -- Birth day
    BIRTH_DATETIME,                -- Complete birth date and time
    RACE_CONCEPT_ID,               -- Concept ID for race
    ETHNICITY_CONCEPT_ID,          -- Concept ID for ethnicity
    LOCATION_ID,                   -- Foreign key to Location table
    PROVIDER_ID,                   -- Foreign key to Provider table
    CARE_SITE_ID,                  -- Foreign key to Care Site table
    PERSON_SOURCE_VALUE,           -- Source value for person identifier
    GENDER_SOURCE_VALUE,           -- Source value for gender
    GENDER_SOURCE_CONCEPT_ID,      -- Source concept ID for gender
    RACE_SOURCE_VALUE,             -- Source value for race
    RACE_SOURCE_CONCEPT_ID,        -- Source concept ID for race
    ETHNICITY_SOURCE_VALUE,        -- Source value for ethnicity
    ETHNICITY_SOURCE_CONCEPT_ID,   -- Source concept ID for ethnicity
    
    -- Custom Non-OMOP Fields
    ETL_MODULE,                    -- ETL module identifier
    phi_PAT_ID,                    -- Protected health information - Patient ID
    phi_MRN_CPI                    -- Protected health information - Medical Record Number

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS PERSON
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = 'PERSON')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON PERSON.PERSON_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL)