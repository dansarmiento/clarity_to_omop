/*******************************************************************************
* Query: Patient Encounter Analysis
* Description: Retrieves 1M patients with both face-to-face and hospital visits
* within the last 3-5 years, ordered by total visit count.
*
* Tables Used:
* - PAT_ENC: Patient Encounters
* - PAT_ENC_HSP: Hospital Patient Encounters
* - IDENTITY_ID: Patient Identifiers
*
* Date Range:
* - Face-to-face visits: Last 3 years
* - Hospital visits: Last 5 years
*******************************************************************************/

-- Common Table Expression for face-to-face encounters
WITH f2f_encounters AS (
    SELECT DISTINCT
        PAT_ENC.PAT_ID,
        COUNT(DISTINCT PAT_ENC.PAT_ENC_CSN_ID) AS f2f_count
    FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC PAT_ENC
    WHERE PAT_ENC.ENC_TYPE_C IN (
        '1000', '1001', '1003', '101', '1021004', '106', '108', '11', 
        '111113', '120', '1200', '1201', '122', '1300', '2', '200', 
        '201', '202', '203', '204', '205', '206', '207', '208', '209', 
        '2100', '2101', '210100', '210200', '2133', '2425', '2500', 
        '2501', '2502', '2506', '2522', '2523', '3', '300', '3015', 
        '3018', '304210', '304214', '3042508', '3042509', '3042716', 
        '50', '5852101', '76', '91'
    )
    AND DATEDIFF(DAY, PAT_ENC.CONTACT_DATE, GETDATE()) BETWEEN 0 AND 365*3
    GROUP BY PAT_ENC.PAT_ID
),

-- Common Table Expression for hospital encounters
hsp_encounters AS (
    SELECT DISTINCT
        PAT_ENC_HSP.PAT_ID,
        COUNT(DISTINCT PAT_ENC_HSP.PAT_ENC_CSN_ID) AS hsp_count
    FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_HSP PAT_ENC_HSP
    WHERE DATEDIFF(DAY, PAT_ENC_HSP.HOSP_ADMSN_TIME, GETDATE()) BETWEEN 0 AND 365*5
    GROUP BY PAT_ENC_HSP.PAT_ID
)

-- Main query to combine and analyze encounter data
SELECT TOP 1000000
    COALESCE(f2f_encounters.PAT_ID, hsp_encounters.PAT_ID) AS EPIC_PAT_ID,
    II.IDENTITY_ID AS mrn,
    f2f_count,
    hsp_count,
    (f2f_count + hsp_count) AS visit_count
FROM f2f_encounters
INNER JOIN hsp_encounters 
    ON f2f_encounters.PAT_ID = hsp_encounters.PAT_ID
INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IDENTITY_ID II
    ON f2f_encounters.PAT_ID = II.PAT_ID 
    AND II.IDENTITY_TYPE_ID = 49
ORDER BY visit_count DESC;