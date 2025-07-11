SELECT  DISTINCT
      ORDER_RESULTS.ORD_VALUE AS SOURCE_CODE
      , ORDER_RESULTS.ORD_VALUE AS SOURCE_NAME
      , COUNT(ORDER_PROC_ID) AS SOURCE_FREQUENCY
FROM
      SH_LAND_EPIC_CLARITY_PROD.DBO.ORDER_RESULTS
LEFT OUTER JOIN SH_LAND_EPIC_CLARITY_PROD.DBO.CLARITY_COMPONENT ON
      ORDER_RESULTS.COMPONENT_ID = CLARITY_COMPONENT.COMPONENT_ID
 
WHERE
      ORDER_RESULTS.ORD_NUM_VALUE = 9999999
      AND 
      CLARITY_COMPONENT.BASE_NAME NOT IN('UNITNUMBER','PLACENTACL','PLACENTACO', 'HYALINECAS', 'FNLRPT', 'MOMMRN', 'GYNCLINICA', 'EXPIRDT',
            'FNACOMMENT', 'BONEMARROW6', 'REFERENCEM', 'PATHCOMMEN', 'FNLRPT')
      AND 
      UPPER(ORDER_RESULTS.ORD_VALUE) NOT IN( 'N', 'NA', '-', '+', '++', '+++', '+-', '=', '--', ':::::', , ' ' 
           'E2701V00', 'E4533V00', 'HCG8070100', 'E3056V00', 'HCG8050009', 'HCG6120200', 'E2700V00', 'E3087V00', 'HCG7050131', 'HCG1012009', 
           'E2684V00', 'E3087V00', 'E6552V00', 'HCG7110052', 'E0336V00', '', 'E0332V00', 'E4532V00', 'E3057V00', 'E4527V00', 'E8332V00',
           'E3088V00', 'E0181V00', 'E8333V00', 'HFNC', 'HFOV', 'HFJV', 'HCG9010040', 'E8333V00', 'HCG9050057', 'HCG0042112', 'HCG1012037', 
           'HCG0032123', 'HCG8120016', 'E4528V00', 'E3046V00', 'E2121V00', 'E3077V00', 'HCG9102029', 'HCG9082013', 'E0179V00', 'E4544V00', 'HCG0092109',
           'HCG9062100', 'HCG9030100', 'HCG0042081' , 'HCG9122081', 'HCG9030033', 
           'LUMBAR PUNCTURE', 'REBECCA L KUNAK, DO', 'MELISSA M BOMBERY, MD', 'MIHAELA D CHISELITE, MD', 'KATHLEEN W MONTGOMERY, MD',
           'FRANCES L ROSARIO QUINONES, MD', 'PETER A MILLWARD, MD', 'ALYSON M BOOTH, MD', 'NATHAN B MCLAMB, MD', 'JENNIFER R STUMPH, MD',
           'BRITNI R BRYANT, MD', 'E4543V00', 'IAN M HARROLD, MD', 'MEGGEN A WALSH, DO', 
           'GROSS HEMOLYSIS', 'TRANSFUSED',  'ON FILE', 'NOTE',  'SEE RBC COMMENTS', 'NOT ON FILE', 'NOT REQUESTED', 'SEE BELOW', '', 
           'BIPAP', 'KLEPNE', 'UNAVAILABLE', 'ACUTE INFLAMMATION.', 'SEE CULTURE REPORT', 'ROOM AIR', 'CEREBROSPINAL FLUID', 'DATES ESTIMATE',
           'UREAPLASMA SPECIES', 'PROPIONIBACTERIUM ACNES', 'C1 PROSTATEFOSSA', 'BLADDER', 'CANALB')
            
      AND   CLARITY_COMPONENT.BASE_NAME NOT LIKE ('SURGPATH%')
      AND   CLARITY_COMPONENT.BASE_NAME NOT LIKE ('EMMI%')
      AND   CLARITY_COMPONENT.BASE_NAME NOT LIKE ('DATE%')
             
      AND CLARITY_COMPONENT.EXTERNAL_NAME NOT LIKE ('%\\%%')
      AND CLARITY_COMPONENT.EXTERNAL_NAME NOT LIKE ('%CHOLESTEROL%')      
      
      AND ORDER_RESULTS.ORD_VALUE NOT LIKE '<%'
      AND ORDER_RESULTS.ORD_VALUE NOT LIKE '>%'
      AND ORDER_RESULTS.ORD_VALUE IS NOT NULL
      AND ORDER_RESULTS.ORD_VALUE <>''  
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%MG/DL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%UG/DL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%UG/ML%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%/UL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%0MM%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%E.U/DL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%E.U./DL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%E.U. /DL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%OTHER%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CREDIT%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%MG%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CFU/ML%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SEE COMMENT%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SEE COMENT%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SATISFACTORY%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SEE SCANNED%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%*%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NOT REQUESTED%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SEE NOTE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%UNKNOWN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%VENT%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%URINE%'

      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PAP%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%VAGINAL%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SYMBOL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NEWBORN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SPECIMEN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PRESERVCYT, CERV%'

      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%HPV%'     
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%A CELL BLOCK WAS EXAMINED AND WAS FOUND TO BE CONSISTENT WITH THE INTERPRETATION%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NORMAL UPPER RESPIRATORY FLORA, NO MRSA OR PSEUDOMONAS AERUGINOSA ISOLATED%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%VAGINOSIS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%MICROBIOTA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CITROBACTER FREUNDII%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%MORAXELLA CATARRHALIS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PENICILLIUM%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%BRONCHIAL ALVEOLAR LAVAGE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%TRICHOPHYTON%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ACINETOBACTER BAUMANNII%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ESCHERICHIA COLI%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NO BACTERIA OR YEAST ISOLATED%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NO GROUP A BETA STREP (STR. PYOGENES) ISOLATED.%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PSEUDOMONAS AERUGINOSA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%KLEBSIELLA PNEUMONIAE SS PNEUMONIAE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%MORGANELLA MORGANII SS MORGANII%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%METHICILLIN RESISTANT STAPH AUREUS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SUGGEST%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%OCC%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CANDIDA ALBICANS%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%STREPTOCOCCI%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ENTEROBACTER%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%STAPHYLOCOCCUS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%EPITHELIAL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%HAEMOPHILUS INFLUENZAE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SERRATIA MARCESCENS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%HERPES SIMPLEX VIRUS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CITROBACTER KOSERI%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%LACTOBACILLUS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%MRSA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%HEMATURIA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NO MYCOPLASMA SP. OR UREAPLASMA SP. ISOLATED.%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ENDOMETRIAL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%INFLAMMATION AND ASSOCIATED CELLULAR CHANGES.%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%DO IF NIL OR ASC-US/AGUS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%THYROID%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ASPERGILLUS FUMIGATUS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%STENOTROPHOMONAS MALTOPHILIA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%BRONCHIAL%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PLACENTA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CANDIDA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%BREAST%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PERITONEAL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%GENITALIA%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ORGANISMS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%KIDNEY%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%LUNG%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%KNEE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PLEURAL%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%GARDNERELLA VAGINALIS%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PERFORMED%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NORMAL RISK%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%LEVOFLOXACIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CEFTAZIDIME%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%ERTAPENEM%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CIPROFLOXACIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%CEFTRIAXONE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%TRIMETHOPRIM/SULFAMETHOXAZOLE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%TETRACYCLINE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%NITROFURANTOIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%PIPERACILLIN/TAZOBACTAM%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%IMIPENEM%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%GENTAMICIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%AMOXICILLIN/CLAVULANATE%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%AMPICILLIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%AMIKACIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%AZTREONAM%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%TOBRAMYCIN%'
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%KLEBSIELLA PNEUMONIAE%'
      
      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%SLIDE SCANNED%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'
--      AND  UPPER(ORDER_RESULTS.ORD_VALUE) NOT LIKE '%XXX%'

GROUP BY
      ORDER_RESULTS.ORD_VALUE
      , ORDER_RESULTS.ORD_NUM_VALUE
HAVING
      COUNT(ORDER_PROC_ID) > 1000
ORDER BY
      COUNT(ORDER_PROC_ID) DESC