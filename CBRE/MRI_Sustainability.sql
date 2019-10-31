select top 10 * from UTMTR with (nolock)
select top 10 * from UTREAD	with (nolock)
select top 10 * from UTTAR	with (nolock)
select top 10 * from UTTEN	with (nolock)
select top 10 * from TB_NABERS_ABCOEFFIECENTS with (nolock)
select top 10 * from TB_NABERS_ADDAREAS	 with (nolock)
select top 10 * from TB_NABERS_ADDHOURS	 with (nolock)
select top 10 * from TB_NABERS_ADDSUBMETER	 with (nolock)
select top 10 * from TB_NABERS_CLIMATEZONE	 with (nolock)
select top 10 * from TB_NABERS_DOCReference	 with (nolock)
select top 10 * from TB_NABERS_HistRating	 with (nolock)
select top 100 * from TB_NABERS_POSTCODE	 with (nolock) WHERE [POSTCODE] > 3000
select top 10 * from TB_NABERS_SGEX	 with (nolock)
select top 10 * from TB_Nabers_submeter	 with (nolock)
select top 1000 * from TB_NABERS_SUSTAINABILITY with (nolock)	

select top 100 *
from [mri_aunz].[dbo].[bldg] with (nolock)
where [BLDGNAME] LIKE '%william%'

select top 100 [projid],*
from [mri_aunz].[dbo].[ENTITY] with (nolock)
where [entityid] = '131173'

select top 100 *
from [mri_aunz].[dbo].[suit] with (nolock)
where [bldgid] = '131173'

BLDGGLA 16110.9000	
-- 16110.9000	

select sum(SUITSQFT)
from [mri_aunz].[dbo].[suit] with (nolock)
where [bldgid] = '131173'


select *
from [mri_aunz].[dbo].[MRIField]
where [fieldname] like '%SQFT%'
ORDER BY [FIELDNAME]


select * from [mri_aunz].[dbo].[BSQF] WHERE [bldgid] = '131173'	--Leased !{Square Feet}
select * from [mri_aunz].[dbo].[SSQF] WHERE [bldgid] = '131173' AND [SQFTTYPE] = 'NLA'

select top 1000
BldgID
,bldgname
,BASEBLDGAREA -- Base Building Area	
,BLDGGLA	--Building G.L.A.	
,OCCGLA	--Occupied GLA	
,TOTALAREA -- Total Building Area	
,AIRCONDESC	--Airconditioning		
,BLDGHRS --Base Building hours per week	
,CERTIFIEDRATING	--CERTIFIEDRATING	
,GREENPOWER	--GREENPOWER	
,POWERDESC	--Power to !{Building}	
,Star	--Star Rating	
FROM [MRI_AUNZ].[dbo].[BLDG] with (nolock)
WHERE [bldgid] = '140839'

select * from [mri_aunz].[dbo].[BSQF] WHERE [bldgid] = '140839'	ORDER BY [EFFDATE]
select * from [mri_aunz].[dbo].[SSQF] WHERE [bldgid] = '140839' AND [SQFTTYPE] = 'NLA'


SELECT *
FROM [MRI_AUNZ].[dbo].[MRIField]
WHERE [TABLENAME] LIKE '%NABER%'
ORDER BY [TABLENAME],[FIELDNAME]





