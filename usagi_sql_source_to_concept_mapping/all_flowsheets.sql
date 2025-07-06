

select distinct 
    fs.flo_meas_id          as  measure_id
    ,fs.flo_meas_name       as  measure_name
    ,fs.disp_name           as  display_name
--    ,fsm.flt_id             as  flowsheet_template_id
    ,count(fsm.meas_value)  as  count_of_entries
--    ,max(fsm.recorded_time) as  max_recorded_time

from SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLO_GP_DATA fs
    inner join SH_LAND_EPIC_CLARITY_PROD.DBO.IP_FLWSHT_MEAS fsm on fsm.flo_meas_id = fs.flo_meas_id

where datediff(year,fsm.recorded_time,getdate()) <= 1

group by fs.flo_meas_id
    ,fs.flo_meas_name
    ,fs.disp_name
    ,fsm.flt_id
ORDER BY count_of_entries desc;