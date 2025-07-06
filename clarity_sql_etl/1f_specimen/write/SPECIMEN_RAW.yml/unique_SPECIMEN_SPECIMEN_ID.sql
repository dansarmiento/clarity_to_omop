
    
    

select
    SPECIMEN_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN
where SPECIMEN_ID is not null
group by SPECIMEN_ID
having count(*) > 1


