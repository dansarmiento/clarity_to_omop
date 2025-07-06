--  sh_flwsht_sdoh_answers_source.sql
--> export file name pattern: sh_flwsht_sdoh_answers_source

 SELECT
      FS.MEAS_VALUE ||'_'|| LOOK_UP_VALUE_INI AS SOURCE_CODE 
      , CASE
            --transportation - medical appt
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19946' THEN 'Yes'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19946' THEN 'No'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19946' THEN 'Patient refused'
            --transportation - daily living
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19947' THEN 'Yes'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19947' THEN 'No'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19947' THEN 'Patient refused'
            --financial resource strain
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19929' THEN 'Very hard'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19929' THEN 'Hard'
            WHEN FS.MEAS_VALUE='3' AND LOOK_UP_VALUE_INI = 'EPT_19929' THEN 'Somewhat hard'
            WHEN FS.MEAS_VALUE='4' AND LOOK_UP_VALUE_INI = 'EPT_19929' THEN 'Not very hard'
            WHEN FS.MEAS_VALUE='5' AND LOOK_UP_VALUE_INI = 'EPT_19929' THEN 'Not hard at all'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19929' THEN 'Patient refused'
            --social connectedness - marriage
            WHEN FS.MEAS_VALUE='3' AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Married'
            WHEN FS.MEAS_VALUE='4' AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Widowed'
            WHEN FS.MEAS_VALUE='5' AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Divorced'
            WHEN FS.MEAS_VALUE='6' AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Separated'
            WHEN FS.MEAS_VALUE='7' AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Never married'
            WHEN FS.MEAS_VALUE='8' AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Living with partner'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19937' THEN 'Patient refused'
            --social connectedness - clubs
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19924' THEN 'Yes'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19924' THEN 'No'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19924' THEN 'Patient refused'
             --food insecurity - worry
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19944' THEN 'Never true'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19944' THEN 'Sometimes true'
            WHEN FS.MEAS_VALUE='3' AND LOOK_UP_VALUE_INI = 'EPT_19944' THEN 'Often true'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19944' THEN 'Patient refused'
             --food insecurity - pay
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19945' THEN 'Never true'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19945' THEN 'Sometimes true'
            WHEN FS.MEAS_VALUE='3' AND LOOK_UP_VALUE_INI = 'EPT_19945' THEN 'Often true'
            WHEN FS.MEAS_VALUE IN ('98','99') AND LOOK_UP_VALUE_INI = 'EPT_19945' THEN 'Patient refused'
             --stress - anxious
            WHEN FS.MEAS_VALUE='1' AND LOOK_UP_VALUE_INI = 'EPT_19927' THEN 'Not at all'
            WHEN FS.MEAS_VALUE='2' AND LOOK_UP_VALUE_INI = 'EPT_19927' THEN 'Only a little '
            WHEN FS.MEAS_VALUE='3' AND LOOK_UP_VALUE_INI = 'EPT_19927' THEN 'To some extent'
            WHEN FS.MEAS_VALUE='4' AND LOOK_UP_VALUE_INI = 'EPT_19927' THEN 'Rather much'
            WHEN FS.MEAS_VALUE='5' AND LOOK_UP_VALUE_INI = 'EPT_19927' THEN 'Very much'
            WHEN FS.MEAS_VALUE IN ('98','99')  AND LOOK_UP_VALUE_INI = 'EPT_19927' THEN 'Patient refused'
              
        END AS SOURCE_NAME
      , count(FS.MEAS_VALUE) AS SOURCE_FREQUENCY
      , FS.FLO_MEAS_NAME AS ADDITIONAL_INFO
      , LOOK_UP_VALUE_INI
FROM
      (
            SELECT
                  MEAS_VALUE
                  , FLO_MEAS_ID
                  , FLO_MEAS_NAME
                  , CAT_INI || '_' || CAT_ITEM AS LOOK_UP_VALUE_INI
            FROM
                  SH_OMOP_DB_PROD.OMOP_CLARITY.OBSERVATION_CLARITYAMB_FLOWSHEET
            UNION ALL
            SELECT
                  MEAS_VALUE
                  , FLO_MEAS_ID
                  , FLO_MEAS_NAME
                  , CAT_INI || '_' || CAT_ITEM AS LOOK_UP_VALUE_INI
            FROM
                  SH_OMOP_DB_PROD.OMOP_CLARITY.OBSERVATION_CLARITYHOSP_FLOWSHEET
      ) AS FS

WHERE SOURCE_CODE IS NOT NULL AND
      (FS.FLO_MEAS_ID IN ('1572879817', '1572879818') --transportation
      OR 
      FS.FLO_MEAS_ID  IN ('1572879823') --stress      
      OR 
      FS.FLO_MEAS_ID  IN ('1572879828','1572879830') --social connectedness
      OR 
      FS.FLO_MEAS_ID  IN ('1572879820','1572879821') --food insecurity
      OR 
      FS.FLO_MEAS_ID  IN ('1572879810') --financial resource strain
      )
GROUP BY FS.MEAS_VALUE
      , FS.LOOK_UP_VALUE_INI
      , FS.FLO_MEAS_NAME

ORDER BY LOOK_UP_VALUE_INI, SOURCE_CODE