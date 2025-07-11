
{{ config(materialized = 'table', schema = 'OMOP_CLARITY') }}
--BEGIN V_OB_DEL_RECORDS_TEMP
--This view collects and displays Universal Charge Line information for Willow charges

--********************************************************************************
--TITLE:   V_OB_DEL_RECORDS
--PURPOSE: PUTS RELEVANT DATA FOR EACH DELIVERY RECORD ON ONE ROW.
--AUTHOR:  JOSH LOVE
--TRANSLATOR: ROGER CARLSON
--PROPERTIES:
--REVISION HISTORY:
--*RC 06/18/2024 - TRANSLATED TO SNOWFLAKE
--********************************************************************************
-- CREATE OR REPLACE VIEW CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.V_OB_DEL_RECORDS
-- AS (
--BEGIN WITH
WITH ANESTH AS(
	SELECT
		BABYID,
	    CAST(REPLACE(REPLACE(REPLACE(ANESC, ' ', '.'), ' ', ', '), '.', ' ') AS VARCHAR) AS ANESTH_CONC
	FROM
		(
		SELECT EPI.OB_DELIVERY_BABY_ID BABYID, LISTAGG(ANESC.NAME, ', ') WITHIN GROUP (ORDER BY ANESC.NAME) AS ANESC
		FROM
		  {{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
		  LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI ON DELIV.SUMMARY_BLOCK_ID=EPI.EPISODE_ID
	      LEFT OUTER JOIN {{source('CLARITY','DELIVERY_ANES_MTHD')}} AS  ANES ON ANES.SUMMARY_BLOCK_ID=DELIV.SUMMARY_BLOCK_ID
	      LEFT OUTER JOIN {{source('CLARITY','ZC_OB_HX_ANESTH')}} AS ANESC ON ANESC.OB_HX_ANESTH_C=ANES.DEL_ANESTH_METHOD_C
	      WHERE DELIV.OB_DEL_EPIS_TYPE_C=10
		  GROUP BY
			EPI.OB_DELIVERY_BABY_ID
	         ) B
)--END WITH
,
--BEGIN WITH
INDUCT AS(
	SELECT
		BABYID,
	   	CAST(REPLACE(REPLACE(REPLACE(INDUCT, ' ', '.'), ' ', ', '), '.', ' ') AS VARCHAR) AS INDUCT_CONC
	FROM
		(
		SELECT EPI.OB_DELIVERY_BABY_ID BABYID, LISTAGG(INDUCTC.NAME, ', ') WITHIN GROUP (ORDER BY INDUCTC.NAME) AS INDUCT
		FROM
			{{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
		LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI ON DELIV.SUMMARY_BLOCK_ID = EPI.EPISODE_ID
		LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_INDUCT')}} AS INDUCT ON INDUCT.SUMMARY_BLOCK_ID = DELIV.SUMMARY_BLOCK_ID
		LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_INDUCT')}} AS  INDUCTC ON INDUCT.OB_DEL_INDUCTION_C = INDUCTC.OBD_INDUCTION_C
		WHERE
			DELIV.OB_DEL_EPIS_TYPE_C = 10
		GROUP BY
			EPI.OB_DELIVERY_BABY_ID
	     ) B
)--END WITH
,
--BEGIN WITH
LACER AS(
	SELECT
		BABYID,
	   	CAST(REPLACE(REPLACE(REPLACE(LACER, ' ', '.'), ' ', ', '), '.', ' ') AS VARCHAR) AS LACER_CONC
	FROM
		(
		SELECT EPI.OB_DELIVERY_BABY_ID BABYID, LISTAGG(LACERC.NAME , ', ') WITHIN GROUP (ORDER BY LACERC.NAME) AS LACER
		FROM {{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
		LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI ON DELIV.SUMMARY_BLOCK_ID = EPI.EPISODE_ID
		LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_LACERAT')}} AS  LACER ON DELIV.SUMMARY_BLOCK_ID = LACER.SUMMARY_BLOCK_ID
		LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_LACER')}} AS  LACERC ON LACER.OB_DEL_LACER_C = LACERC.OBD_LACERATIONS_C
		WHERE
			DELIV.OB_DEL_EPIS_TYPE_C = 10
		GROUP BY
			EPI.OB_DELIVERY_BABY_ID
	     ) B
)--END WITH
,
--BEGIN WITH
EPISIO AS(
	SELECT
		BABYID,
	   	CAST(REPLACE(REPLACE(REPLACE(EPISIO, ' ', '.'), ' ', ', '), '.', ' ') AS VARCHAR) AS EPISIO_CONC
	FROM
		(
		 SELECT EPI.OB_DELIVERY_BABY_ID BABYID, LISTAGG(EPISIOC.NAME , ', ') WITHIN GROUP (ORDER BY EPISIOC.NAME) AS EPISIO
	     FROM {{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
		 LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI ON DELIV.SUMMARY_BLOCK_ID=EPI.EPISODE_ID
	     LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_EPISIO')}} AS  EPISIO ON EPISIO.SUMMARY_BLOCK_ID=DELIV.SUMMARY_BLOCK_ID
	     LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_EPISIO')}} AS  EPISIOC ON EPISIOC.OBD_EPISIOTOMY_C=EPISIO.OB_DEL_EPISIO_C
	     WHERE
			DELIV.OB_DEL_EPIS_TYPE_C = 10
		 GROUP BY
			EPI.OB_DELIVERY_BABY_ID
	     ) B
)--END WITH
,
--BEGIN WITH
AUGMENT AS(
	SELECT
		BABYID,
	   	CAST(REPLACE(REPLACE(REPLACE(AUGMENT, ' ', '.'), ' ', ', '), '.', ' ') AS VARCHAR) AS AUGMENT_CONC
	FROM
		(
		 SELECT EPI.OB_DELIVERY_BABY_ID BABYID, LISTAGG(AUGMENTC.NAME , ', ') WITHIN GROUP (ORDER BY AUGMENTC.NAME) AS AUGMENT
	     FROM {{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
		 LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI ON DELIV.SUMMARY_BLOCK_ID=EPI.EPISODE_ID
	     LEFT OUTER JOIN  {{source('CLARITY','OB_HSB_DEL_AUGMENT')}} AS  AUGMENT ON DELIV.SUMMARY_BLOCK_ID=AUGMENT.SUMMARY_BLOCK_ID
	     LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_AUGMENT')}} AS  AUGMENTC ON AUGMENT.OB_DEL_AUGMENT_C=AUGMENTC.OB_DEL_AUGMENT_C
	     WHERE
			DELIV.OB_DEL_EPIS_TYPE_C = 10
		 GROUP BY
			EPI.OB_DELIVERY_BABY_ID
		) B
)--END WITH
,
--BEGIN WITH
CERVRIPE AS(
	SELECT
		BABYID,
	   	CAST(REPLACE(REPLACE(REPLACE(CERVRIPE, ' ', '.'), ' ', ', '), '.', ' ') AS VARCHAR) AS CERVRIPE_CONC
	FROM
		(
		 SELECT EPI.OB_DELIVERY_BABY_ID BABYID, LISTAGG(CERVRIPEC.NAME , ', ') WITHIN GROUP (ORDER BY CERVRIPEC.NAME) AS CERVRIPE
	     FROM {{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
		 LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI ON DELIV.SUMMARY_BLOCK_ID=EPI.EPISODE_ID
	     LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_RIPETYP')}} AS  CERVRIPE ON CERVRIPE.SUMMARY_BLOCK_ID=DELIV.SUMMARY_BLOCK_ID
	     LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_CERVRIPE')}} AS  CERVRIPEC ON CERVRIPE.OBD_CERV_RIPE_TP_C=CERVRIPEC.OBD_CERV_RIPE_T_C
	     WHERE
			DELIV.OB_DEL_EPIS_TYPE_C = 10
		 GROUP BY
			EPI.OB_DELIVERY_BABY_ID
		) B
)--END WITH

SELECT
	A.BABYID,
	A.MOMID,
	A.DELRECID,
	A.DELMETH,
	CAST((CASE WHEN GA LIKE '%/%' THEN REPLACE(REPLACE(GA,' ','w '),'/7','d')
			ELSE GA||'w' END) AS VARCHAR(30))  AS GA,
	A.PROV,
	--replace Epic udf-- EPIC_UTIL.EFN_UTC_TO_LOCAL(DELDATE) AS DELDATE,
	CONVERT_TIMEZONE ('EST',A.DELDATE::DATETIME) AS DELDATE,
	A.LIVING,
	COALESCE(CAST(ROUND(CAST(A.APGAR1 AS FLOAT),1) AS VARCHAR),'*Unknown') AS APGAR1,
	COALESCE(CAST(ROUND(CAST(A.APGAR5 AS FLOAT),1) AS VARCHAR),'*Unknown') AS APGAR5,
	COALESCE(CAST(A.APGAR10 AS VARCHAR(10)),'*Unknown') AS APGAR10 ,
	COALESCE(CAST(FLOOR(A.BIRTHWT*(28.35))AS VARCHAR(10)),'*Unknown') AS BIRTHWT,

	--COLLECT AND CONCATENATE THE VALUES FOR COLUMNS THAT MAY HAVE MULTIPLE RESPONSES FOR EACH BABY
	-- CTEs above
	INDUCT.INDUCT_CONC,
	ANESTH.ANESTH_CONC,
	LACER.LACER_CONC,
	EPISIO.EPISIO_CONC,
	AUGMENT.AUGMENT_CONC,
	CERVRIPE.CERVRIPE_CONC,

	A.DEPT,
	A.BABYNAME,
	A.MOMNAME,
	A.PROVID,
	A.EPISODEID,
	A.MOM_CSN,
	A.BABY_CSN

FROM (
  	SELECT  DELIV.SUMMARY_BLOCK_ID AS DELRECID, DELIV.OB_DEL_DELIV_MD_ID AS PROVID,
            DELIV.OB_DEL_BIRTH_DTTM AS DELDATE, DELIV.OB_DEL_BIRTH_WT AS BIRTHWT,
            DELIV.OB_DELIVERY_BABY_ID AS BABYID,  SER.PROV_NAME AS PROV, PAT_EPIS.PAT_ID AS MOMID, INDUCTC.NAME AS INDUCT,
			ANESTHC.NAME AS ANESTH, LACERC.NAME AS LACER, DELIV.OB_DEL_DELIV_METH_C AS DELMETH,
			LIVING.DEL_LIVING_STATUS_C AS LIVING, EPISIOC.NAME AS EPISIO, AUGC.NAME AS AUGMENT,
			BABY_3.PED_APGAR_ONE_C AS APGAR1,BABY_3.PED_APGAR_FIVE_C AS  APGAR5, BABY_3.PED_APGAR_TEN_C AS  APGAR10,
			RIPEC.NAME AS CERVRIPE, BABY.PAT_NAME AS BABYNAME, MOM.PAT_NAME AS MOMNAME, BABY.PED_GEST_AGE AS GA,
			DELIV.OB_DEL_DEPT AS DEPT, DELIV.OB_DEL_PREG_EPI_ID AS EPISODEID,
			DELIV.DELIVERY_DATE_CSN AS MOM_CSN, DELIV.BABY_BIRTH_CSN AS BABY_CSN
	FROM (
			SELECT	deliv.SUMMARY_BLOCK_ID, deliv.OB_DEL_EPIS_TYPE_C, deliv.OB_DEL_DELIV_MD_ID, deliv.OB_DEL_BIRTH_DTTM,
				deliv.OB_DEL_BIRTH_WT,  deliv.OB_DEL_DELIV_METH_C, deliv.OB_DEL_DEPT, epi1.OB_DELIVERY_BABY_ID,
				COALESCE(epi1.OB_DEL_PREG_EPI_ID, epi2.OB_DEL_PREG_EPI_ID) AS OB_DEL_PREG_EPI_ID, deliv.DELIVERY_DATE_CSN,
				deliv.BABY_BIRTH_CSN
			FROM
				{{source('CLARITY','OB_HSB_DELIVERY')}} AS  DELIV
				INNER JOIN {{source('CLARITY','EPISODE')}} AS  EPI1 ON deliv.SUMMARY_BLOCK_ID=epi1.EPISODE_ID
				LEFT OUTER JOIN {{source('CLARITY','EPISODE')}} AS  EPI2 ON epi1.OB_DEL_REC_COPY_ID=epi2.EPISODE_ID
			WHERE epi1.OB_DELIVERY_BABY_ID IS NOT NULL
				AND (epi1.OB_DEL_PREG_EPI_ID IS NOT NULL OR epi2.OB_DEL_PREG_EPI_ID IS NOT NULL)
				AND epi1.STATUS_C<>3
		) DELIV

	LEFT OUTER JOIN {{source('CLARITY','PAT_EPISODE')}} AS  PAT_EPIS ON DELIV.OB_DEL_PREG_EPI_ID = PAT_EPIS.EPISODE_ID
	LEFT OUTER JOIN {{source('CLARITY','DELIVERY_ANES_MTHD')}} AS  ANSTH ON DELIV.SUMMARY_BLOCK_ID=ANSTH.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_INDUCT')}} AS  IND ON DELIV.SUMMARY_BLOCK_ID=IND.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_LACERAT')}} AS  LAC ON DELIV.SUMMARY_BLOCK_ID=LAC.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_EPISIO')}} AS  EPISIO ON DELIV.SUMMARY_BLOCK_ID=EPISIO.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_AUGMENT')}} AS  AUG ON DELIV.SUMMARY_BLOCK_ID=AUG.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','OB_HSB_DEL_RIPETYP')}} AS  RIPE ON DELIV.SUMMARY_BLOCK_ID=RIPE.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','CLARITY_SER')}} AS  SER ON DELIV.OB_DEL_DELIV_MD_ID=SER.PROV_ID
	LEFT OUTER JOIN {{source('CLARITY','DELIVERY_LIV_STS')}} AS  LIVING ON DELIV.SUMMARY_BLOCK_ID=LIVING.SUMMARY_BLOCK_ID
	LEFT OUTER JOIN {{source('CLARITY','ZC_OB_HX_ANESTH')}} AS  ANESTHC ON ANESTHC.OB_HX_ANESTH_C=ANSTH.DEL_ANESTH_METHOD_C
	LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_INDUCT')}} AS  INDUCTC ON IND.OB_DEL_INDUCTION_C=INDUCTC.OBD_INDUCTION_C
	LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_LACER')}} AS  LACERC ON LAC.OB_DEL_LACER_C=LACERC.OBD_LACERATIONS_C
	LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_EPISIO')}} AS  EPISIOC ON EPISIO.OB_DEL_EPISIO_C=EPISIOC.OBD_EPISIOTOMY_C
	LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_AUGMENT')}} AS  AUGC ON AUG.OB_DEL_AUGMENT_C=AUGC.OB_DEL_AUGMENT_C
	LEFT OUTER JOIN {{source('CLARITY','ZC_OB_DEL_CERVRIPE')}} AS  RIPEC ON RIPE.OBD_CERV_RIPE_TP_C=RIPEC.OBD_CERV_RIPE_T_C
	LEFT OUTER JOIN {{source('CLARITY','PATIENT')}} AS  BABY ON BABY.PAT_ID=DELIV.OB_DELIVERY_BABY_ID
	LEFT OUTER JOIN {{source('CLARITY','PATIENT')}} AS  MOM ON MOM.PAT_ID=PAT_EPIS.PAT_ID
	LEFT OUTER JOIN {{source('CLARITY','PATIENT_3')}} AS  BABY_3 ON BABY.PAT_ID=BABY_3.PAT_ID

	WHERE DELIV.OB_DEL_EPIS_TYPE_C=10
	) A
--ANESC
LEFT JOIN ANESTH ON A.BABYID=ANESTH.BABYID
--INDUCT
LEFT JOIN INDUCT ON A.BABYID=INDUCT.BABYID
--INDUCT
LEFT JOIN LACER ON A.BABYID=LACER.BABYID
--EPISIO
LEFT JOIN EPISIO ON A.BABYID=EPISIO.BABYID
--AUGMENT
LEFT JOIN AUGMENT ON A.BABYID=AUGMENT.BABYID
--CERVRIPE
LEFT JOIN CERVRIPE ON A.BABYID=CERVRIPE.BABYID

GROUP BY
	A.BABYID,
	A.MOMID,
	A.DELRECID,
	A.DELMETH,
	A.GA,
	A.PROV,
	A.DELDATE,
	A.LIVING,
	A.APGAR1,
	A.APGAR5,
	A.APGAR10,
	A.BIRTHWT,
	INDUCT.INDUCT_CONC,
	ANESTH.ANESTH_CONC,
	LACER.LACER_CONC,
	EPISIO.EPISIO_CONC,
	AUGMENT.AUGMENT_CONC,
	CERVRIPE.CERVRIPE_CONC,
	A.DEPT,
	A.BABYNAME,
	A.MOMNAME,
	A.PROVID,
	A.EPISODEID,
	A.MOM_CSN,
	A.BABY_CSN
-- ); -- END CREATE VIEW

