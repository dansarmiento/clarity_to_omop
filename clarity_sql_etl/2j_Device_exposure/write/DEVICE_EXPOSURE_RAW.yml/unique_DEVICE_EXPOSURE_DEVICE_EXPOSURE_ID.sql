
    
    

select
    DEVICE_EXPOSURE_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE
where DEVICE_EXPOSURE_ID is not null
group by DEVICE_EXPOSURE_ID
having count(*) > 1


