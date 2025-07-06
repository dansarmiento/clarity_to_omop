
    
    

select
    VISIT_OCCURRENCE_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
where VISIT_OCCURRENCE_ID is not null
group by VISIT_OCCURRENCE_ID
having count(*) > 1


