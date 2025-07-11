--LOCATION


SELECT DISTINCT
     LOCATION_ID
    , ADDRESS_1
    , ADDRESS_2
    , CITY
    , STATE
    , ZIP
    , COUNTY
    , LOCATION_SOURCE_VALUE

FROM
 CARE_RES_OMOP_GEN_WKSP.OMOP.LOCATION_RAW AS LOCATION

LEFT JOIN (
    SELECT CDT_ID
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE (STANDARD_DATA_TABLE = 'LOCATION')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
        ) AS EXCLUSION_RECORDS
        ON LOCATION.LOCATION_ID = EXCLUSION_RECORDS.CDT_ID
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL)