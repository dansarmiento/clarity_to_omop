
    
    

select
    PROCEDURE_OCCURRENCE_ID as unique_field,
    count(*) as n_records

from CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE
where PROCEDURE_OCCURRENCE_ID is not null
group by PROCEDURE_OCCURRENCE_ID
having count(*) > 1


