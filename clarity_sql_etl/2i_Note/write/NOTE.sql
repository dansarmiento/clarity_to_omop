/*******************************************************************************
* Query: Note Data Retrieval
* Description: Retrieves note-related information from the NOTE_RAW table while
*              excluding records with fatal or invalid data errors.
* Tables: 
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT
    -- OMOP Standard Fields
    NOTE_ID,                        -- Unique identifier for the note
    PERSON_ID,                      -- Reference to the person
    NOTE_DATE,                      -- Date of the note
    NOTE_DATETIME,                  -- Date and time of the note
    NOTE_TYPE_CONCEPT_ID,           -- Type of note concept identifier
    NOTE_CLASS_CONCEPT_ID,          -- Class of note concept identifier
    NOTE_TITLE,                     -- Title of the note
    NOTE_TEXT,                      -- Actual note content
    ENCODING_CONCEPT_ID,            -- Encoding type concept identifier
    LANGUAGE_CONCEPT_ID,            -- Language concept identifier
    PROVIDER_ID,                    -- Reference to the provider
    VISIT_OCCURRENCE_ID,            -- Reference to the visit
    VISIT_DETAIL_ID,               -- Reference to visit details
    NOTE_SOURCE_VALUE,              -- Human readable source value
    NOTE_EVENT_ID,                  -- Event identifier
    NOTE_EVENT_FIELD_CONCEPT_ID,    -- Event field concept identifier

    -- Non-OMOP Fields
    ETL_MODULE,                     -- ETL module identifier
    phi_PAT_ID,                     -- Patient identifier
    phi_MRN_CPI,                    -- Medical record number
    phi_CSN_ID,                     -- CSN identifier

    -- Source Link Fields
    src_TABLE,                      -- Source table reference
    src_FIELD,                      -- Source field reference
    src_VALUE_ID                    -- Source value identifier

    -- Commented out Note Link Fields
    -- , note_TABLE
    -- , note_FIELD
    -- , note_VALUE_ID

FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE

    -- Join to exclude records with fatal or invalid data errors
    LEFT JOIN (
        SELECT 
            CDT_ID
        FROM 
            CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE 
            (STANDARD_DATA_TABLE = 'NOTE')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON NOTE.NOTE_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    (EXCLUSION_RECORDS.CDT_ID IS NULL);