/*******************************************************************************
* Script Name: QRY_NOTE.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This query joins the NOTE table to OMOP vocabularies for data validation
*******************************************************************************/

WITH note_data AS (
    SELECT
        NOTE.NOTE_ID,                    
        NOTE.PERSON_ID,                  
        NOTE.NOTE_DATETIME,              
        NOTE.NOTE_TYPE_CONCEPT_ID || '::' || c1.CONCEPT_NAME AS NOTE_TYPE,  
        NOTE.NOTE_CLASS_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS NOTE_CLASS,
        NOTE.NOTE_TITLE,                 
        NOTE.NOTE_TEXT,                  
        NOTE.ENCODING_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS ENCODING,    
        NOTE.LANGUAGE_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS LANGUAGE,    
        PROVIDER.PROVIDER_NAME,          
        NOTE.VISIT_OCCURRENCE_ID,      
        NOTE.NOTE_SOURCE_VALUE,        
        'NOTE' AS SDT_TAB,             
        VISIT_OCCURRENCE.PERSON_ID || 
        NOTE_SOURCE_VALUE || 
        NOTE_DATETIME AS NK,            
        NOTE.ETL_MODULE,               
        NOTE.PHI_PAT_ID,             
        NOTE.PHI_MRN_CPI,             
        NOTE.PHI_CSN_ID,              
        NOTE.SRC_TABLE,               
        NOTE.SRC_FIELD,                 
        NOTE.SRC_VALUE_ID               
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON NOTE.NOTE_TYPE_CONCEPT_ID = c1.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON NOTE.NOTE_CLASS_CONCEPT_ID = c2.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON NOTE.ENCODING_CONCEPT_ID = c3.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON NOTE.LANGUAGE_CONCEPT_ID = c4.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON NOTE.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
        ON NOTE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT *
FROM note_data;

/*******************************************************************************
* Column Descriptions:
* NOTE_ID              - Primary key for the note record
* PERSON_ID            - Reference to the person associated with the note
* NOTE_DATETIME        - Timestamp of note creation
* NOTE_TYPE            - Concatenated concept ID and name for note type
* NOTE_CLASS           - Concatenated concept ID and name for note classification
* NOTE_TITLE           - Header or title of the note
* NOTE_TEXT            - Actual content of the note
* ENCODING             - Concatenated concept ID and name for note encoding
* LANGUAGE             - Concatenated concept ID and name for note language
* PROVIDER_NAME        - Name of the healthcare provider who created the note
* VISIT_OCCURRENCE_ID  - Reference to associated visit
* NOTE_SOURCE_VALUE    - Original source value of the note
* SDT_TAB              - Constant indicating source table
* NK                   - Generated natural key for the record
* ETL_MODULE           - Identifier for ETL process
* PHI_PAT_ID          - Protected patient identifier
* PHI_MRN_CPI         - Protected medical record number
* PHI_CSN_ID          - Protected CSN identifier
* SRC_TABLE           - Original source table name
* SRC_FIELD           - Original source field name
* SRC_VALUE_ID        - Original source value identifier
*
* Logic:
* 1. Joins NOTE table with CONCEPT table four times to get concept names for:
*    - Note Type
*    - Note Class
*    - Encoding
*    - Language
* 2. Links to PROVIDER table to get provider names
* 3. Links to VISIT_OCCURRENCE table for visit information
* 4. Creates a natural key (NK) by concatenating PERSON_ID, NOTE_SOURCE_VALUE, 
*    and NOTE_DATETIME
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including, but not limited to, the implied warranties of 
* merchantability and fitness for a particular purpose. The entire risk as to 
* the quality and performance of the code is with you. Should the code prove 
* defective, you assume the cost of all necessary servicing, repair or correction.
*******************************************************************************/