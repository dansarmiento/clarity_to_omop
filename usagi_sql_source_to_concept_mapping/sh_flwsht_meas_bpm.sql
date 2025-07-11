--  sh_flwsht_meas_bpm.sql
--> export file name pattern: sh_flwsht_meas_bpm_source

SELECT DISTINCT 
    FS.FLO_MEAS_ID          AS  SOURCE_CODE
    ,FS.FLO_MEAS_NAME       AS  SOURCE_NAME
    ,FS.DISP_NAME           AS  ADDITIONAL_INFO
    ,COUNT(FSM.MEAS_VALUE)  AS  SOURCE_FREQUENCY

FROM SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLO_GP_DATA FS
    INNER JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLWSHT_MEAS FSM ON FSM.FLO_MEAS_ID = FS.FLO_MEAS_ID

WHERE --DATEDIFF(YEAR,FSM.RECORDED_TIME,GETDATE()) <= 1 AND 
      (FS.FLO_MEAS_NAME  LIKE ('%MEAN%') 
and 
      FS.DISP_NAME  LIKE ('%BP%') 
      )
GROUP BY FS.FLO_MEAS_ID
    ,FS.FLO_MEAS_NAME
    ,FS.DISP_NAME

ORDER BY SOURCE_FREQUENCY DESC;