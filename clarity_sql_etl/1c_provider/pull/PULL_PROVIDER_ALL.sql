/*******************************************************************************
* Query: PULL_PROVIDER_ALL
* Description: Retrieves provider information from various CLARITY tables
* Author: [Author Name]
* Created: [Date]
* Modified: [Date]
*******************************************************************************/

SELECT DISTINCT
    -- Stage Attributes
    CLARITY_SER.PROV_ID                                 AS PROVIDER_ID,
    CLARITY_SER.PROV_NAME                              AS PROVIDER_NAME,
    CLARITY_SER_2.NPI                                  AS NPI,
    CLARITY_SER.DEA_NUMBER                             AS DEA,
    YEAR(CLARITY_SER.BIRTH_DATE)                       AS YEAR_OF_BIRTH,
    CAST(SEX_C AS VARCHAR(1)) || ':' || ZC_SEX.NAME    AS GENDER_SOURCE_VALUE,
    COALESCE(ZC_SPECIALTY.NAME, CLARITY_SER.PROV_TYPE) AS SPECIALTY_SOURCE_VALUE,

    -- Additional Attributes for Verification
    TRY_TO_NUMBER(CLARITY_SER.PROV_ID, '9999999999', 38, 0) AS TRYTONUMBER,
    ZC_SPECIALTY.SPECIALTY_C,
    ZC_SPECIALTY.NAME,
    COALESCE(CLARITY_DEP_SER_2.REV_LOC_ID, 
             CLARITY_DEP_EMP.REV_LOC_ID)               AS REV_LOC_ID,
    CLARITY_SER.BIRTH_DATE,
    CLARITY_SER.PROV_TYPE,
    CLARITY_SER.SEX_C,
    ZC_SEX.NAME                                        AS ZC_SEX_NAME

FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_SER AS CLARITY_SER

    -- Join for sex/gender information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_SEX AS ZC_SEX
        ON ZC_SEX.RCPT_MEM_SEX_C = CLARITY_SER.SEX_C

    -- Join for additional provider information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_SER_2 AS CLARITY_SER_2
        ON CLARITY_SER.PROV_ID = CLARITY_SER_2.PROV_ID

    -- Join for department information from SER_2
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_DEP AS CLARITY_DEP_SER_2
        ON CLARITY_SER_2.PRIMARY_DEPT_ID = CLARITY_DEP_SER_2.DEPARTMENT_ID

    -- Join for provider hierarchy information
    LEFT OUTER JOIN CARE_BRONZE_CLARITY_PROD.DBO.D_PROV_PRIMARY_HIERARCHY AS D_PROV_PRIMARY_HIERARCHY
        ON CLARITY_SER.PROV_ID = D_PROV_PRIMARY_HIERARCHY.PROV_ID

    -- Join for specialty information
    LEFT OUTER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_SPECIALTY AS ZC_SPECIALTY
        ON D_PROV_PRIMARY_HIERARCHY.SPECIALTY_C = ZC_SPECIALTY.SPECIALTY_C

    -- Join for employee information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EMP AS CLARITY_EMP
        ON CLARITY_SER.PROV_ID = CLARITY_EMP.PROV_ID

    -- Join for department information from EMP
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_DEP AS CLARITY_DEP_EMP
        ON CLARITY_EMP.LGIN_DEPARTMENT_ID = CLARITY_DEP_EMP.DEPARTMENT_ID

WHERE 
    -- Exclude specific provider types
    CLARITY_SER.PROV_TYPE NOT IN ('RESOURCE', 'LABORATORY')
    -- Ensure PROV_ID is a valid number
    AND TRY_TO_NUMBER(CLARITY_SER.PROV_ID, '9999999999', 38, 0) IS NOT NULL
    -- Remove duplicates caused by leading zeros
    AND LEFT(CLARITY_SER.PROV_ID, 1) <> '0'

-- Ensure only one record per provider
QUALIFY 1 = ROW_NUMBER() OVER (
    PARTITION BY CLARITY_SER.PROV_ID
    ORDER BY CLARITY_SER.PROV_NAME
)