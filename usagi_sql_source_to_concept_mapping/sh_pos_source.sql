
--Select count(pos_id) as [count], pos_type from
--
--(Select distinct pos.*
-- PCP physician PointOfService
--from
--                --epiccare.OMOP.AoU_Driver_prod AS aou
--                epiccare.OMOP.AoU_Driver AS aou
--                INNER JOIN
--                                EpicClarity.dbo.PATient
--                                ON
--                                                PATIENT.PAT_ID = aou.Epic_Pat_id
--                
--                INNER JOIN
--                                EpicClarity.dbo.CLARITY_POS AS pos
--                                ON
--                                                PATIENT.[CUR_PRIM_LOC_ID] = pos.POS_ID
--
--union
--Encounter physician PointOfService
--Select distinct pos.*
--from
--                --epiccare.OMOP.AoU_Driver_prod AS aou
--                epiccare.OMOP.AoU_Driver AS aou
--                INNER JOIN
--                                EpicClarity.dbo.PAT_ENC
--                                ON
--                                                pat_enc.PAT_ID = aou.Epic_Pat_id
--				left join
--                                EpicClarity.dbo.CLARITY_DEP
--                                ON
--                                                PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
--                left JOIN
--                                EpicClarity.dbo.CLARITY_POS AS pos
--                                ON
--                                               CLARITY_DEP.REV_LOC_ID = pos.POS_ID
--) as all_pos
--group by pos_type

---------------------------------------------------------------------------------------------------------------------
/*Convert to Snowflake*/
SELECT COUNT(POS_ID) AS SOURCE_FREQUENCY, POS_TYPE AS SOURCE_NAME FROM
		(SELECT DISTINCT POS.*
		-- PCP physician PointOfService
		FROM

		                SH_OMOP_DB_PROD.OMOP.AOU_DRIVER AS AOU
		                INNER JOIN
		                                SH_LAND_EPIC_CLARITY_PROD.DBO.PATIENT AS PATIENT
		                                ON
		                                                PATIENT.PAT_ID = aou.Epic_Pat_id
		                
		                INNER JOIN
		                                SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_POS AS POS
		                                ON
		                                                PATIENT.CUR_PRIM_LOC_ID = POS.POS_ID
		
		UNION
		--Encounter physician PointOfService
		SELECT DISTINCT POS.*
		FROM
		                --epiccare.OMOP.AoU_Driver_prod AS aou
		                SH_OMOP_DB_PROD.OMOP.AOU_DRIVER AS AOU
		                INNER JOIN
		                                SH_LAND_EPIC_CLARITY_PROD.DBO.PAT_ENC AS PAT_ENC
		                                ON
		                                                PAT_ENC.PAT_ID = AOU.EPIC_PAT_ID
						LEFT JOIN
		                                SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_DEP AS CLARITY_DEP
		                                ON
		                                                PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
		                LEFT JOIN
		                                SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_POS AS POS
		                                ON
		                                                CLARITY_DEP.REV_LOC_ID = POS.POS_ID
		) AS ALL_POS
GROUP BY POS_TYPE
ORDER BY SOURCE_FREQUENCY DESC
--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------
/* Without limiting to AOU Participants */
/*SELECT COUNT(POS_ID) AS COUNT, POS_TYPE FROM

(SELECT DISTINCT POS.*
-- PCP physician PointOfService
FROM
 				SH_LAND_EPIC_CLARITY_PROD.DBO.PATIENT AS PATIENT
                INNER JOIN
                                SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_POS AS POS
                                ON
                                                PATIENT.CUR_PRIM_LOC_ID = POS.POS_ID

UNION
--Encounter physician PointOfService
SELECT DISTINCT POS.*
FROM
			  	SH_LAND_EPIC_CLARITY_PROD.DBO.PAT_ENC AS PAT_ENC
				LEFT JOIN
                                SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_DEP AS CLARITY_DEP
                                ON
                                                PAT_ENC.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID
                LEFT JOIN
                                SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_POS AS POS
                                ON
                                                CLARITY_DEP.REV_LOC_ID = POS.POS_ID
) AS ALL_POS
GROUP BY POS_TYPE
ORDER BY COUNT */
------------------------------------------------------------------------------------------------------------------------------