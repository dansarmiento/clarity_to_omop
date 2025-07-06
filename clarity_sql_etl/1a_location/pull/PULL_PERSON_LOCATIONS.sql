/*******************************************************************************
* Procedure: PULL_PERSON_LOCATIONS
* Description: Retrieves unique patient location information, combining address 
*              details into a single location source value.
*
* Tables:
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER
*   - CARE_BRONZE_CLARITY_PROD.DBO.PATIENT
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY
*
* Returns:
*   - ADDRESS_1: Primary address line
*   - ADDRESS_2: Secondary address line
*   - CITY: City name
*   - STATE: Two-letter state abbreviation
*   - ZIP: Five-digit ZIP code
*   - COUNTY: County name
*   - LOCATION_SOURCE_VALUE: Concatenated location information (max 50 chars)
*******************************************************************************/

SELECT
    DISTINCT 
    MIN(PATIENT.ADD_LINE_1) AS ADDRESS_1,
    MIN(PATIENT.ADD_LINE_2) AS ADDRESS_2,
    MIN(PATIENT.CITY) AS CITY,
    MIN(LEFT(ZC_STATE.ABBR, 2)) AS STATE,
    MIN(LEFT(PATIENT.ZIP, 5)) AS ZIP,
    MIN(ZC_COUNTY.NAME) AS COUNTY,
    LEFT(
        COALESCE(PATIENT.ADD_LINE_1, '') ||
        COALESCE(PATIENT.ADD_LINE_2, '') ||
        COALESCE(PATIENT.CITY, '') ||
        COALESCE(LEFT(ZC_STATE.ABBR, 2), '') ||
        COALESCE(PATIENT.ZIP, '') ||
        COALESCE(ZC_COUNTY.COUNTY_C, ''),
        50
    ) AS LOCATION_SOURCE_VALUE

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
    -- Join with patient information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.PATIENT AS PATIENT
        ON PATIENT.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID
    -- Join with state reference data
    LEFT OUTER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE AS ZC_STATE
        ON PATIENT.STATE_C = ZC_STATE.STATE_C
    -- Join with county reference data
    LEFT OUTER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_COUNTY AS ZC_COUNTY
        ON PATIENT.COUNTY_C = ZC_COUNTY.COUNTY_C

GROUP BY 
    LEFT(
        COALESCE(PATIENT.ADD_LINE_1, '') ||
        COALESCE(PATIENT.ADD_LINE_2, '') ||
        COALESCE(PATIENT.CITY, '') ||
        COALESCE(LEFT(ZC_STATE.ABBR, 2), '') ||
        COALESCE(PATIENT.ZIP, '') ||
        COALESCE(ZC_COUNTY.COUNTY_C, ''),
        50
    );