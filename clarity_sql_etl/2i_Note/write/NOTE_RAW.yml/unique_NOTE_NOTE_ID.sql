
    
    

select
    NOTE_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE
where NOTE_ID is not null
group by NOTE_ID
having count(*) > 1


