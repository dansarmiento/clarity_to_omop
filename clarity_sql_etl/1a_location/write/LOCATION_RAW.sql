/***************************************************************
 * Query: LOCATION Selection
 * Description: Retrieves unique location records with standardized formatting
 * Source: STAGE_LOCATION_ALL
 * Target: LOCATION table in OMOP CDM
 ***************************************************************/

SELECT DISTINCT
    -- Generate unique location identifier
    CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW_SEQ.nextval::NUMBER(28,0) AS LOCATION_ID,
    
    -- Address components
    ADDRESS_1::VARCHAR        AS ADDRESS_1,      -- Primary address line
    ADDRESS_2::VARCHAR        AS ADDRESS_2,      -- Secondary address line
    CITY::VARCHAR            AS CITY,           -- City name
    STATE::VARCHAR           AS STATE,          -- State/province
    ZIP::VARCHAR             AS ZIP,            -- Postal code
    COUNTY::VARCHAR          AS COUNTY,         -- County name
    
    -- Original source value
    LOCATION_SOURCE_VALUE::VARCHAR AS LOCATION_SOURCE_VALUE  -- Original location identifier

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_LOCATION_ALL AS T

