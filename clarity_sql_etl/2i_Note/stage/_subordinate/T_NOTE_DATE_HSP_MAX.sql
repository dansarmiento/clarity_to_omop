/*******************************************************************************
* Query to retrieve maximum contact dates for pull notes
* 
* This query selects the unique PULL_NOTE_ID and finds the latest contact date
* from the PULL_NOTE_HOSP_ALL table.
*
* Tables:
*   CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_HOSP_ALL
*
* Columns returned:
*   - PULL_NOTE_ID: Unique identifier for pull notes
*   - MAX_CONTACT_DATE_REAL: Maximum (latest) contact date for each note
*******************************************************************************/

SELECT 
    PULL_NOTE_ID,
    -- PULL_NOTE_LINE is commented out but retained for reference
    -- ,PULL_NOTE_LINE
    MAX(PULL_CONTACT_DATE_REAL) AS MAX_CONTACT_DATE_REAL
FROM  
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_NOTE_HOSP_ALL AS PULL_NOTE_HOSP_ALL
GROUP BY 
    PULL_NOTE_ID
    -- ,PULL_NOTE_LINE 