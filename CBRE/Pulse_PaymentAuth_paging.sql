--DECLARE @entityID char(6) = '110076' -- Braddon Central (the small one)
DECLARE @entityID char(6) = '131310' -- Eastland Shopping Centre (the big one)

-- user settable/selectable, on change refresh list of pages
DECLARE @rowsToFetch int = 100;
SELECT @rowsToFetch as [Number of rows to fetch];

-- total lines
DECLARE @totalRows int = (
SELECT COUNT(*)
FROM [MRI_AUNZ].[dbo].[HIST] h WITH (nolock)
WHERE h.[CASHTYPE] = 'OP'
       AND h.[CHECKPD] IS NULL  
       AND h.[STATUS] NOT IN ('U','C','W','D','V','T') 
       AND ((h.[ATAXID] IS NOT NULL AND (h.[TRANSFERITEM] = 'N' OR h.[TRANSFERITEM] IS NULL)) OR h.[ATAXID] IS NULL) 
       AND h.[ENTITYID] = @entityID
       AND h.[TAXITEM] = 'N'
);
SELECT @totalRows as [Total rows available];

-- build list of available pages, show as clickable items ??
WITH lv0 AS (SELECT 0 g UNION ALL SELECT 0)
       ,lv1 AS (SELECT 0 g FROM lv0 a CROSS JOIN lv0 b) -- 4 rows
       ,lv2 AS (SELECT 0 g FROM lv1 a CROSS JOIN lv1 b) -- 16 rows
       ,lv3 AS (SELECT 0 g FROM lv2 a CROSS JOIN lv2 b) -- 256 rows
       ,Tally (n) AS (SELECT 0 UNION ALL SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM lv3
)
SELECT DISTINCT t.[n] 
FROM Tally t
WHERE t.[n] <= CASE WHEN @totalRows <= @rowsToFetch THEN 0 ELSE (@totalRows / @rowsToFetch)-1 END

-- which page number we want to show
DECLARE @pageNumber int = 0;

SELECT 
       h.[STATUS], h.[PONUM], ph.[ORDSTAT], v.[VENDNME1], h.[INVOICE], h.[ITEMAMT]
       , h.[ATAXAMT], h.[ACCTNUM], g.[ACCTNAME], i.[INVCDATE], i.[DUEDATE], h.[VENDID]
       , i.[FROMDATE], i.[TODATE], i.[AUTHID], i.[AUTHDATE], i.[AUTHLOC]
FROM MRI_AUNZ.dbo.hist h WITH (nolock)
       inner join [MRI_AUNZ].[dbo].[INVC] i ON h.[VENDID] = i.[VENDID] AND h.[INVOICE] = i.[INVOICE] AND h.[EXPPED] = i.[EXPPED]
       left join [MRI_AUNZ].[dbo].[POHD] ph WITH (nolock) ON h.[PONUM] = ph.[PONUM]
       inner join [MRI_AUNZ].[dbo].[VEND] v WITH (nolock) ON h.[VENDID] = v.[VENDID]
       inner join [MRI_AUNZ].[dbo].[GACC] g WITH (nolock) ON h.[ACCTNUM] = g.[ACCTNUM]
WHERE h.[CASHTYPE] = 'OP'
       AND h.[CHECKPD] IS NULL  
       AND h.[STATUS] NOT IN ('U','C','W','D','V','T') 
       AND ((h.[ATAXID] IS NOT NULL AND (h.[TRANSFERITEM] = 'N' OR h.[TRANSFERITEM] IS NULL)) OR h.[ATAXID] IS NULL) 
       AND h.[ENTITYID] = @entityID
       AND h.[TAXITEM] = 'N'
ORDER BY h.[STATUS], h.[VENDID], h.[INVOICE], h.[EXPPED]
OFFSET (@pageNumber * @rowsToFetch) ROWS FETCH NEXT @rowsToFetch ROWS ONLY;

