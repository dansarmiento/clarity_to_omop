/***************************************************************
 * Query Name: STAGE_LOCATION_ALL
 * Description: This query combines person and care site locations
 *              from two different tables into a unified view
 * 
 * Tables Used:
 * 1. PULL_PERSON_LOCATIONS - Contains individual person addresses
 * 2. PULL_CARE_SITE_LOCATIONS - Contains care site addresses
 *
 * Created: [Date]
 * Modified: [Date]
 ***************************************************************/

-- Combine person locations and care site locations
SELECT
    ADDRESS_1                  -- Primary address line
    ,ADDRESS_2                 -- Secondary address line
    ,CITY                      -- City name
    ,STATE                     -- State code
    ,ZIP                       -- ZIP/Postal code
    ,COUNTY                    -- County name
    ,LOCATION_SOURCE_VALUE     -- Original source value for the location

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_PERSON_LOCATIONS

UNION ALL  -- Combines results while keeping duplicates

SELECT
    ADDRESS_1                  -- Primary address line
    ,ADDRESS_2                 -- Secondary address line
    ,CITY                      -- City name
    ,STATE                     -- State code
    ,ZIP                       -- ZIP/Postal code
    ,COUNTY                    -- County name
    ,LOCATION_SOURCE_VALUE     -- Original source value for the location

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_CARE_SITE_LOCATIONS;