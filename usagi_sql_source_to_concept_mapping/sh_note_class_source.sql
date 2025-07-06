SELECT  
        ZC_NOTE_TYPE_IP.TYPE_IP_C || hno_info.AMB_NOTE_YN AS SOURCE_CODE
        , ZC_NOTE_TYPE_IP.NAME    as SOURCE_NAME
         , COUNT(HNO_INFO.NOTE_ID) AS SOURCE_FREQUENCY
		 , case
			when hno_info.AMB_NOTE_YN = 'Y'
			then 'Outpatient'
			else 'Inpatient'
		end as io
FROM
        SH_LAND_EPIC_CLARITY_PROD.DBO.NOTE_ENC_INFO AS NOTE_ENC_INFO
           INNER JOIN
                     SH_LAND_EPIC_CLARITY_PROD.DBO.HNO_INFO as HNO_INFO
                      ON
                                 NOTE_ENC_INFO.NOTE_ID = HNO_INFO.NOTE_ID
           INNER JOIN
                    SH_LAND_EPIC_CLARITY_PROD.DBO.PAT_ENC as PAT_ENC
                      ON
                                 PAT_ENC.PAT_ENC_CSN_ID = HNO_INFO.PAT_ENC_CSN_ID
           INNER JOIN
                    SH_LAND_EPIC_CLARITY_PROD.DBO.ZC_NOTE_TYPE_IP as ZC_NOTE_TYPE_IP
                      ON
                                 HNO_INFO.IP_NOTE_TYPE_C = ZC_NOTE_TYPE_IP.TYPE_IP_C
GROUP BY
           ZC_NOTE_TYPE_IP.TYPE_IP_C
         , ZC_NOTE_TYPE_IP.NAME, hno_info.AMB_NOTE_YN

order by ZC_NOTE_TYPE_IP.TYPE_IP_C
