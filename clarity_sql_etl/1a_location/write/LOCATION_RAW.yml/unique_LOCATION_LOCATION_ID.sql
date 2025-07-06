
    
    

select
    LOCATION_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_GEN_WKSP.OMOP.LOCATION
where LOCATION_ID is not null
group by LOCATION_ID
having count(*) > 1


