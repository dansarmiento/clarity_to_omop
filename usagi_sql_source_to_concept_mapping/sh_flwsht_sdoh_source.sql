--  sh_flwsht_sdoh.sql
--> export file name pattern: sh_flwsht_shoh_source

SELECT DISTINCT 
    FS.FLO_MEAS_ID          AS  SOURCE_CODE
    ,FS.FLO_MEAS_NAME       AS  SOURCE_NAME
    ,COUNT(FSM.MEAS_VALUE)  AS  SOURCE_FREQUENCY
    ,FS.DISP_NAME           AS  ADDITIONAL_INFO
    
FROM SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLO_GP_DATA FS
    INNER JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLWSHT_MEAS FSM ON FSM.FLO_MEAS_ID = FS.FLO_MEAS_ID

WHERE 
      FS.FLO_MEAS_ID  IN ('1572879817','1572879818') --transportation
      OR 
      FS.FLO_MEAS_ID  IN ('1572879823') --stress      
      OR 
      FS.FLO_MEAS_ID  IN ('1572879828','1572879830') --social connectedness
      OR 
      FS.FLO_MEAS_ID  IN ('1572879820','1572879821') --food insecurity
      OR 
      FS.FLO_MEAS_ID  IN ('1572879810') --financial resource strain
--      OR 
--      FS.FLO_MEAS_ID  IN ('999','9999') --housing (not done)


      GROUP BY FS.FLO_MEAS_ID
    ,FS.FLO_MEAS_NAME
    ,FS.DISP_NAME

ORDER BY SOURCE_FREQUENCY DESC;
