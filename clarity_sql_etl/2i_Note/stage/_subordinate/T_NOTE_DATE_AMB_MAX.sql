/*******************************************************************************
* Query to retrieve maximum contact dates for pull notes
* 
* This query selects the unique PULL_NOTE_ID and finds the latest contact date
* from the PULL_NOTE_AMB_ALL table.
*
* Tables:
*   CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_AMB_ALL
*
* Created: [Date]
* Modified: [Date]
*******************************************************************************/

SELECT 
    PULL_NOTE_ID,                          -- Unique identifier for pull notes
    -- PULL_NOTE_LINE,                     -- Line number within pull note (currently commented out)
    MAX(PULL_CONTACT_DATE_REAL) AS MAX_CONTACT_DATE_REAL  -- Latest contact date for each note
FROM  
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_AMB_ALL AS PULL_NOTE_AMB_ALL
GROUP BY 
    PULL_NOTE_ID                           -- Group results by note ID
    -- ,PULL_NOTE_LINE                     -- Grouping by line number currently disabled