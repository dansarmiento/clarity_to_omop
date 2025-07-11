/****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNT([ORDER_PROC_ID]) AS [COUNT]

      ,[MODIFIER1_ID]
	  ,CM.[MODIFIER_NAME]


  FROM [EpicClarity].[dbo].[ORDER_PROC]

      LEFT JOIN
        [EpicClarity].[dbo].[CLARITY_MOD] AS CM
        ON
            [ORDER_PROC].[MODIFIER1_ID] = CM.[MODIFIER_ID]

WHERE [MODIFIER1_ID] IS NOT NULL

GROUP BY       [MODIFIER1_ID]
	  ,CM.[MODIFIER_NAME]

ORDER BY [COUNT] DESC
