 --  CONDITION_ERA.sql (derived)
 
 /****************************************************
Condition Eras
This script will insert values into the CONDITION_ERA table given that the CONDITION_OCCURRENCE table is populated. 
It will string together condition records that have <= 30 days between them into eras during which the Person
 is assumed to have the given condition. 
 https://ohdsi.github.io/CommonDataModel/sqlScripts.html#Condition_Eras
 */

{{ config(materialized = 'table', schema = 'OMOP') }}

-- create base eras from the concepts found in condition_occurrence
WITH cteConditionTarget AS 
(
SELECT co.PERSON_ID
    ,co.condition_concept_id
    ,co.CONDITION_START_DATE
    ,COALESCE(co.CONDITION_END_DATE, DATEADD(day, 1, CONDITION_START_DATE)) AS CONDITION_END_DATE

FROM {{ref('CONDITION_OCCURRENCE')}} co
)
,

cteCondEndDates AS 
(
SELECT PERSON_ID
    ,CONDITION_CONCEPT_ID
    ,DATEADD(day, - 30, EVENT_DATE) AS END_DATE -- unpad the end date
FROM (
    SELECT E1.PERSON_ID
        ,E1.CONDITION_CONCEPT_ID
        ,E1.EVENT_DATE
        ,COALESCE(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) START_ORDINAL
        ,E1.OVERALL_ORD
    FROM (
        SELECT PERSON_ID
            ,CONDITION_CONCEPT_ID
            ,EVENT_DATE
            ,EVENT_TYPE
            ,START_ORDINAL
            ,ROW_NUMBER() OVER (
                PARTITION BY PERSON_ID
                ,CONDITION_CONCEPT_ID ORDER BY EVENT_DATE
                    ,EVENT_TYPE
                ) AS OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
        FROM (
            -- select the start dates, assigning a row number to each
            SELECT PERSON_ID
                ,CONDITION_CONCEPT_ID
                ,CONDITION_START_DATE AS EVENT_DATE
                ,- 1 AS EVENT_TYPE
                ,ROW_NUMBER() OVER (
                    PARTITION BY PERSON_ID
                    ,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
                    ) AS START_ORDINAL
            FROM cteConditionTarget
            UNION ALL
            -- pad the end dates by 30 to allow a grace period for overlapping ranges.
            SELECT PERSON_ID
                ,CONDITION_CONCEPT_ID
                ,DATEADD(day, 30, CONDITION_END_DATE)
                ,1 AS EVENT_TYPE
                ,NULL
            FROM cteConditionTarget
            ) RAWDATA
        ) E1
    INNER JOIN (
        SELECT PERSON_ID
            ,CONDITION_CONCEPT_ID
            ,CONDITION_START_DATE AS EVENT_DATE
            ,ROW_NUMBER() OVER (
                PARTITION BY PERSON_ID
                ,CONDITION_CONCEPT_ID ORDER BY CONDITION_START_DATE
                ) AS START_ORDINAL
        FROM cteConditionTarget
        ) E2 ON E1.PERSON_ID = E2.PERSON_ID
        AND E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID
        AND E2.EVENT_DATE <= E1.EVENT_DATE
    GROUP BY E1.PERSON_ID
        ,E1.CONDITION_CONCEPT_ID
        ,E1.EVENT_DATE
        ,E1.START_ORDINAL
        ,E1.OVERALL_ORD
    ) E
WHERE (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0
)
,

cteConditionEnds AS
(
SELECT c.PERSON_ID
    ,c.CONDITION_CONCEPT_ID
    ,c.CONDITION_START_DATE
    ,MIN(e.END_DATE) AS ERA_END_DATE

FROM cteConditionTarget c
INNER JOIN cteCondEndDates e ON c.PERSON_ID = e.PERSON_ID
    AND c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
    AND e.END_DATE >= c.CONDITION_START_DATE
GROUP BY c.PERSON_ID
    ,c.CONDITION_CONCEPT_ID
    ,c.CONDITION_START_DATE
    )

SELECT row_number() OVER (
        ORDER BY PERSON_ID
        )::NUMBER(28,0) AS CONDITION_ERA_ID
    ,PERSON_ID::NUMBER(28,0) AS PERSON_ID
    ,CONDITION_CONCEPT_ID::NUMBER(28,0) AS CONDITION_CONCEPT_ID
    ,min(CONDITION_START_DATE)::DATE AS CONDITION_ERA_START_DATE
    ,ERA_END_DATE ::DATE AS CONDITION_ERA_END_DATE
    ,COUNT(*)::NUMBER(28,0) AS CONDITION_OCCURRENCE_COUNT
FROM cteConditionEnds
GROUP BY person_id
    ,CONDITION_CONCEPT_ID
    ,ERA_END_DATE