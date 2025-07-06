--STAGE_FACT_RELATIONSHIP_MOM_AND_BABY
--   {{ config(materialized = 'view', schema = 'OMOP_STAGE') }}

SELECT DISTINCT
    56                             AS DOMAIN_CONCEPT_ID_1  --PERSON
    ,PULL_MOM_PERSON_ID            AS FACT_ID_1
    ,56                            AS DOMAIN_CONCEPT_ID_2
    ,PULL_BABY_PERSON_ID           AS FACT_ID_2
    ,4277283                       AS RELATIONSHIP_CONCEPT_ID --NATURAL BIOLOGICAL MOTHER
	-------- Non-OMOP Fields ------------
    ,'STAGE_FACT_RELATIONSHIP_MOM_AND_BABY'   AS ETL_MODULE
    ,PULL_BABY_ID                           AS STAGE_BABY_ID
    ,PULL_MOM_ID                            AS STAGE_MOM_ID
FROM {{ ref('PULL_FACT_RELATIONSHIP_MOM_AND_BABY')}} AS PULL_FACT_RELATIONSHIP_MOM_AND_BABY


UNION ALL

SELECT DISTINCT
    56                                      AS DOMAIN_CONCEPT_ID_1
    ,PULL_BABY_PERSON_ID                    AS FACT_ID_1
    ,56                                     AS DOMAIN_CONCEPT_ID_2
    ,PULL_MOM_PERSON_ID                     AS FACT_ID_2
    ,CASE GENDER_CONCEPT_ID
        WHEN 8532 THEN 4308126 --NATURAL BIOLOGICAL DAUGHTER
        WHEN 8507 THEN 4014096 --NATURAL BIOLOGICAL SON
        ELSE 4326600 --	NATURAL BIOLOGICAL CHILD
    END                                     AS RELATIONSHIP_CONCEPT_ID

	-------- Non-OMOP Fields ------------
    ,'STAGE_FACT_RELATIONSHIP_MOM_AND_BABY'   AS ETL_MODULE
    ,PULL_BABY_ID                           AS STAGE_BABY_ID
    ,PULL_MOM_ID                            AS STAGE_MOM_ID

FROM {{ ref('PULL_FACT_RELATIONSHIP_MOM_AND_BABY')}} AS PULL_FACT_RELATIONSHIP_MOM_AND_BABY
LEFT JOIN {{ ref('PERSON')}} AS P ON (P.PERSON_ID = PULL_BABY_PERSON_ID)

