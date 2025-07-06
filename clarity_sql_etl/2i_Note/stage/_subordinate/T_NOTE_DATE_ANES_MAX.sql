/*******************************************************************************
* Query to retrieve maximum contact dates for pull notes
* 
* This query selects the unique PULL_NOTE_ID and finds the latest contact date
* from the PULL_NOTE_ANES_ALL table.
*
* Tables:
*   CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_ANES_ALL
*
* Columns Retrieved:
*   - PULL_NOTE_ID: Unique identifier for pull notes
*   - MAX_CONTACT_DATE_REAL: Maximum contact date for each pull note
*******************************************************************************/

SELECT 
    PULL_NOTE_ID,
    -- PULL_NOTE_LINE,  -- Commented out but retained for reference
    MAX(PULL_CONTACT_DATE_REAL) AS MAX_CONTACT_DATE_REAL
FROM  
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_ANES_ALL AS PULL_NOTE_ANES_ALL
GROUP BY 
    PULL_NOTE_ID
    -- PULL_NOTE_LINE  -- Commented out but retained for reference
;