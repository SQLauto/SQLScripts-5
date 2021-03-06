select * 
from MRI_AUNZ.dbo.hist WITH (nolock)
where HIST.CASHTYPE = 'OP'
and HIST.CHECKPD IS NULL  
 AND HIST.STATUS NOT IN ('U','C','W','D','V','T') 
 AND ((HIST.ATAXID IS NOT NULL AND (HIST.TRANSFERITEM = 'N' OR HIST.TRANSFERITEM IS NULL)) OR HIST.ATAXID IS NULL) 
 AND HIST.ENTITYID ='131310' 
 AND HIST.TAXITEM = 'N'

select LEFT(RTRIM([INVOICE]),6) as [INV], COUNT(*) AS [COUNT_VEND]
from MRI_AUNZ.dbo.hist WITH (nolock)
where HIST.CASHTYPE = 'OP'
and HIST.CHECKPD IS NULL  
 AND HIST.STATUS NOT IN ('U','C','W','D','V','T') 
 AND ((HIST.ATAXID IS NOT NULL AND (HIST.TRANSFERITEM = 'N' OR HIST.TRANSFERITEM IS NULL)) OR HIST.ATAXID IS NULL) 
 AND HIST.ENTITYID ='131310' 
 AND HIST.TAXITEM = 'N'
GROUP BY LEFT(RTRIM([INVOICE]),6);

select VENDID, COUNT(*) AS [COUNT_VEND]
from MRI_AUNZ.dbo.hist WITH (nolock)
where HIST.CASHTYPE = 'OP'
and HIST.CHECKPD IS NULL  
 AND HIST.STATUS NOT IN ('U','C','W','D','V','T') 
 AND ((HIST.ATAXID IS NOT NULL AND (HIST.TRANSFERITEM = 'N' OR HIST.TRANSFERITEM IS NULL)) OR HIST.ATAXID IS NULL) 
 AND HIST.ENTITYID ='131310' 
 AND HIST.TAXITEM = 'N'
GROUP BY VENDID;

select EXPPED, COUNT(*) AS [COUNT_EXPPED]
from MRI_AUNZ.dbo.hist WITH (nolock)
where HIST.CASHTYPE = 'OP'
and HIST.CHECKPD IS NULL  
 AND HIST.STATUS NOT IN ('U','C','W','D','V','T') 
 AND ((HIST.ATAXID IS NOT NULL AND (HIST.TRANSFERITEM = 'N' OR HIST.TRANSFERITEM IS NULL)) OR HIST.ATAXID IS NULL) 
 AND HIST.ENTITYID ='131310' 
 AND HIST.TAXITEM = 'N'
GROUP BY EXPPED;

select STATUS, COUNT(*) AS [COUNT_STATUS]
from MRI_AUNZ.dbo.hist WITH (nolock)
where HIST.CASHTYPE = 'OP'
and HIST.CHECKPD IS NULL  
 AND HIST.STATUS NOT IN ('U','C','W','D','V','T') 
 AND ((HIST.ATAXID IS NOT NULL AND (HIST.TRANSFERITEM = 'N' OR HIST.TRANSFERITEM IS NULL)) OR HIST.ATAXID IS NULL) 
 AND HIST.ENTITYID ='131310' 
 AND HIST.TAXITEM = 'N'
 GROUP BY STATUS;
