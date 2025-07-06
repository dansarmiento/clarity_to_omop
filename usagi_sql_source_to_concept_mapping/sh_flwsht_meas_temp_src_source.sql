--  sh_flwsht_meas_temp_src_source.sql
--> export file name pattern: sh_flwsht_meas_temp_src_source

SELECT DISTINCT 
      COALESCE (FSM.MEAS_VALUE, '99999')   AS  SOURCE_CODE
      ,CASE 
            WHEN FSM.MEAS_VALUE = '1' THEN 'Oral'
            WHEN FSM.MEAS_VALUE = '101' THEN 'Temporal'
            WHEN FSM.MEAS_VALUE = '102' THEN 'Bladder'
            WHEN FSM.MEAS_VALUE = '103' THEN 'Core'
            WHEN FSM.MEAS_VALUE = '104' THEN 'Esophageal'
            WHEN FSM.MEAS_VALUE = '105' THEN 'Nasopharyngeal'
            WHEN FSM.MEAS_VALUE = '106' THEN 'Skin'
            WHEN FSM.MEAS_VALUE = '107' THEN 'Telehealth'
            WHEN FSM.MEAS_VALUE = '2' THEN 'Tympanic'
            WHEN FSM.MEAS_VALUE = '3' THEN 'Rectal'
            WHEN FSM.MEAS_VALUE = '4' THEN 'Axillary'
            WHEN FSM.MEAS_VALUE = '5' THEN 'Anesthesia'
            ELSE  'Other'
      END AS  SOURCE_NAME
    ,COUNT(FSM.MEAS_VALUE)  AS  SOURCE_FREQUENCY

FROM SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLO_GP_DATA FS
    INNER JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLWSHT_MEAS FSM ON FSM.FLO_MEAS_ID = FS.FLO_MEAS_ID

WHERE --DATEDIFF(YEAR,FSM.RECORDED_TIME,GETDATE()) <= 1 AND 
      FS.FLO_MEAS_ID  ='7'
GROUP BY 
      MEAS_VALUE
ORDER BY SOURCE_FREQUENCY DESC;