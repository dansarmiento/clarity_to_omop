
{{ config(materialized = 'ephemeral') }}
--BEGIN V_OB_DEL_RECORDS_stg
--This view collects and displays Universal Charge Line information for Willow charges

SELECT
	BABYID
	, MOMID
	, DELRECID
	, DELMETH
	, GA
	, PROV
	, DELDATE
	, LIVING
	, APGAR1
	, APGAR5
	, APGAR10
	, BIRTHWT
	, INDUCT_CONC
	, ANESTH_CONC
	, LACER_CONC
	, EPISIO_CONC
	, AUGMENT_CONC
	, CERVRIPE_CONC
	, DEPT
	, BABYNAME
	, MOMNAME
	, PROVID
	, EPISODEID
	, MOM_CSN
	, BABY_CSN
FROM
	{{ref('V_OB_DEL_RECORDS_TEMP')}} AS  V_OB_DEL_RECORDS_TEMP
--END V_OB_DEL_RECORDS_stg
--

