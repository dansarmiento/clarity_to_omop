
    
    

select
    MEASUREMENT_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT
where MEASUREMENT_ID is not null
group by MEASUREMENT_ID
having count(*) > 1


