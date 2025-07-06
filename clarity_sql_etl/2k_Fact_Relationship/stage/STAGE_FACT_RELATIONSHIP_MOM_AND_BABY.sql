/*******************************************************************************
* Script: STAGE_FACT_RELATIONSHIP_MOM_AND_BABY
* Description: Creates relationships between mothers and their babies in two ways:
*             1. Mother to child relationship
*             2. Child to mother relationship (with gender-specific relationships)
*******************************************************************************/

-- First part: Mother to Baby relationship
SELECT DISTINCT
    56                                          AS DOMAIN_CONCEPT_ID_1,    -- PERSON domain
    PULL_MOM_PERSON_ID                         AS FACT_ID_1,              -- Mother's person ID
    56                                          AS DOMAIN_CONCEPT_ID_2,    -- PERSON domain
    PULL_BABY_PERSON_ID                        AS FACT_ID_2,              -- Baby's person ID
    4277283                                    AS RELATIONSHIP_CONCEPT_ID, -- NATURAL BIOLOGICAL MOTHER
    -- Non-OMOP Fields
    'STAGE_FACT_RELATIONSHIP_MOM_AND_BABY'     AS ETL_MODULE,
    PULL_BABY_ID                              AS STAGE_BABY_ID,
    PULL_MOM_ID                               AS STAGE_MOM_ID
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_FACT_RELATIONSHIP_MOM_AND_BABY AS PULL_FACT_RELATIONSHIP_MOM_AND_BABY

UNION ALL

-- Second part: Baby to Mother relationship (with gender-specific relationships)
SELECT DISTINCT
    56                                          AS DOMAIN_CONCEPT_ID_1,    -- PERSON domain
    PULL_BABY_PERSON_ID                        AS FACT_ID_1,              -- Baby's person ID
    56                                          AS DOMAIN_CONCEPT_ID_2,    -- PERSON domain
    PULL_MOM_PERSON_ID                         AS FACT_ID_2,              -- Mother's person ID
    CASE GENDER_CONCEPT_ID
        WHEN 8532 THEN 4308126                 -- NATURAL BIOLOGICAL DAUGHTER
        WHEN 8507 THEN 4014096                 -- NATURAL BIOLOGICAL SON
        ELSE 4326600                           -- NATURAL BIOLOGICAL CHILD
    END                                        AS RELATIONSHIP_CONCEPT_ID,
    -- Non-OMOP Fields
    'STAGE_FACT_RELATIONSHIP_MOM_AND_BABY'     AS ETL_MODULE,
    PULL_BABY_ID                              AS STAGE_BABY_ID,
    PULL_MOM_ID                               AS STAGE_MOM_ID
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_FACT_RELATIONSHIP_MOM_AND_BABY AS PULL_FACT_RELATIONSHIP_MOM_AND_BABY
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON AS P 
        ON (P.PERSON_ID = PULL_BABY_PERSON_ID)