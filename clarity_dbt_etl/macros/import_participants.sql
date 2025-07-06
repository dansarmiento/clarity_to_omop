{%- macro import_participants() -%}


  {%- set query -%}
  -- allows multiple statements
    alter session set multi_statement_count = 0
  {%- endset -%}
  {%- do run_query(query) -%}


  {%- set query -%}
  -- import participant list
    REMOVE @CDM.AOU_PARTICIPANTS;
  {%- endset -%}
  {%- do run_query(query) -%}

  {%- set query -%}

    PUT 'FILE://X:/ALL OF US/OMOP_WORKING/EXPORT/ALLOFUSPARTICIPANT_PYAPI.CSV' @CDM.AOU_PARTICIPANTS;
 
    TRUNCATE TABLE OMOP.ALLOFUSPARTICIPANTS;

    COPY INTO OMOP.ALLOFUSPARTICIPANTS FROM '@CDM.AOU_PARTICIPANTS/ALLOFUSPARTICIPANT_PYAPI.CSV.gz' FILE_FORMAT = 'CDM.OMOP_CSV_FILE_FORMAT' ON_ERROR = 'ABORT_STATEMENT' PURGE = FALSE;

  {%- endset -%}
  {%- do run_query(query) -%}

{%- do log("Completed Macro: import_participants  " , info=true) -%}

{%- endmacro -%}