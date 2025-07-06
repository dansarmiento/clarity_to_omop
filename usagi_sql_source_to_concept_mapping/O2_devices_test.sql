WITH Template_Count AS 

(select count(*) as num_rows, flt.template_id, flt.template_name,
flt.display_name as template_display_name 
from EpicClarity.DBO.ip_flo_gp_data ip
join EpicClarity.DBO.ip_flwsht_meas flo on ip.flo_meas_id = flo.flo_meas_id
join EpicClarity.DBO.ip_flt_data flt on flo.flt_id = flt.template_id
where ((lower(ip.flo_meas_name) like '%o2 device%'
or lower(ip.flo_meas_name) like '%oxygen device%')
or (
  lower(flo.meas_value) like '%nasal cannula%'
  or lower(flo.meas_value) like '%high flow%'
  or lower(flo.meas_value) like '%bipap%'
  or lower(flo.meas_value) like '%vented%'
  or lower(flo.meas_value) like '%room air%'
))
and flo.recorded_time >= '2020-03-01 00:00'
group by flt.template_id, flt.template_name,
flt.display_name
having count(*) > 200 --adjust as needed
--order by num_rows desc
)

select count(*) as num_rows, ip.flo_meas_id, ip.flo_meas_name, ip.disp_name
from EpicClarity.dbo.ip_flo_gp_data ip
join EpicClarity.dbo.ip_flwsht_meas flo on ip.flo_meas_id = flo.flo_meas_id
join EpicClarity.dbo.ip_flt_data flt on flo.flt_id = flt.template_id
where flt.template_id in(SELECT template_id FROM Template_Count)
and 
(
  (
    lower(ip.flo_meas_name) like '%o2 device%'
    or lower(ip.flo_meas_name) like '%oxygen device%'
  )
or (
  lower(flo.meas_value) like '%nasal cannula%'
  or lower(flo.meas_value) like '%high flow%'
  or lower(flo.meas_value) like '%bipap%'
  or lower(flo.meas_value) like '%vented%'
  or lower(flo.meas_value) like '%room air%'
  )
)
and flo.recorded_time >= '2020-03-01 00:00'
group by ip.flo_meas_id, ip.flo_meas_name, ip.disp_name
having count(*) > 200 --adjust as needed
order by num_rows desc
