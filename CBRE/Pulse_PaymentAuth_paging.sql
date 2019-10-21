--DECLARE @entityID char(6) = '110076' -- Braddon Central (the small one)
DECLARE @entityID char(6) = '131310' -- Eastland Shopping Centre (the big one)
-- user settable/selectable, on change refresh list of pages
DECLARE @linesToFetch int = 10;

-- total lines
DECLARE @totalLines int = (
SELECT COUNT(*)
FROM [MRI_AUNZ].[dbo].[HIST] h WITH (nolock)
WHERE h.[CASHTYPE] = 'OP'
       AND h.[CHECKPD] IS NULL  
       AND h.[STATUS] NOT IN ('U','C','W','D','V','T') 
       AND ((h.[ATAXID] IS NOT NULL AND (h.[TRANSFERITEM] = 'N' OR h.[TRANSFERITEM] IS NULL)) OR h.[ATAXID] IS NULL) 
       AND h.[ENTITYID] = @entityID
       AND h.[TAXITEM] = 'N'
);

-- build list of available pages
DECLARE @availPages varchar(50) = '< unset >';
WITH lv0 AS (SELECT 0 g UNION ALL SELECT 0)
       ,lv1 AS (SELECT 0 g FROM lv0 a CROSS JOIN lv0 b) -- 4 lines
       ,lv2 AS (SELECT 0 g FROM lv1 a CROSS JOIN lv1 b) -- 16 lines
       ,lv3 AS (SELECT 0 g FROM lv2 a CROSS JOIN lv2 b) -- 256 lines
       ,Tally (n) AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM lv3
)
, lineCount AS (
    SELECT COUNT(*) as [totalLines]
    FROM [MRI_AUNZ].[dbo].[HIST] h WITH (nolock)
    WHERE h.[CASHTYPE] = 'OP'
       AND h.[CHECKPD] IS NULL  
       AND h.[STATUS] NOT IN ('U','C','W','D','V','T') 
       AND ((h.[ATAXID] IS NOT NULL AND (h.[TRANSFERITEM] = 'N' OR h.[TRANSFERITEM] IS NULL)) OR h.[ATAXID] IS NULL) 
       AND h.[ENTITYID] = @entityID
       AND h.[TAXITEM] = 'N'
)
-- list of pages for drop-down list
SELECT DISTINCT t.[n] as [Page]
FROM Tally t
    CROSS JOIN [lineCount] lc
WHERE t.[n] <= CASE WHEN lc.[totalLines] <= @linesToFetch THEN 1 ELSE (lc.[totalLines] / @linesToFetch) END

-- -- build comma seperated list ??
-- SELECT @availPages = STUFF(( 
-- 	SELECT  ',' + CAST(x.[n] as varchar(10))
--     FROM ( 
-- 			SELECT DISTINCT t.[n] 
-- 			FROM Tally t
--                 CROSS JOIN [lineCount] lc
-- 			WHERE t.[n] <= CASE WHEN lc.[totalLines] <= @linesToFetch THEN 1 ELSE (lc.[totalLines] / @linesToFetch) END
-- 		) x
-- 		FOR XML PATH('')
-- 	), 1, 1, '') 


-- just for example and testing, randomly select which page number we want to show
DECLARE @pageNumber int = 0;
WITH lv0 AS (SELECT 0 g UNION ALL SELECT 0)
       ,lv1 AS (SELECT 0 g FROM lv0 a CROSS JOIN lv0 b) -- 4 lines
       ,lv2 AS (SELECT 0 g FROM lv1 a CROSS JOIN lv1 b) -- 16 lines
       ,lv3 AS (SELECT 0 g FROM lv2 a CROSS JOIN lv2 b) -- 256 lines
       ,Tally (n) AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM lv3
)
, lineCount AS (
    SELECT COUNT(*) as [totalLines]
    FROM [MRI_AUNZ].[dbo].[HIST] h WITH (nolock)
    WHERE h.[CASHTYPE] = 'OP'
       AND h.[CHECKPD] IS NULL  
       AND h.[STATUS] NOT IN ('U','C','W','D','V','T') 
       AND ((h.[ATAXID] IS NOT NULL AND (h.[TRANSFERITEM] = 'N' OR h.[TRANSFERITEM] IS NULL)) OR h.[ATAXID] IS NULL) 
       AND h.[ENTITYID] = @entityID
       AND h.[TAXITEM] = 'N'
)
, numList as (
    -- list of pages for drop-down list
    SELECT DISTINCT t.[n] as [Page]
    FROM Tally t
        CROSS JOIN [lineCount] lc
    WHERE t.[n] <= CASE WHEN lc.[totalLines] <= @linesToFetch THEN 1 ELSE (lc.[totalLines] / @linesToFetch) END
    -- -- split comma seperated string
    -- SELECT n - Len(REPLACE(LEFT(@availPages,n),',','')) + 1 AS [Page]
    --     ,CAST(Substring(@availPages,n,Charindex(',',@availPages + ',',n) - n) AS INT) AS [Element]
    -- FROM (SELECT @availPages AS arr) AS a
    --     JOIN Tally ON n <= Len(@availPages)
    --         AND Substring(',' + @availPages,n,1) = ','
)
, listWithMax as (
    SELECT [Page], MAX([Page]) OVER() as [maxPage]
    FROM [numList]
)
-- need to have subtract 1 for zero based offset
SELECT @pageNumber = ISNULL((CEILING(RAND()*[maxPage])-1),0)
FROM [listWithMax];

-- what did we calculate
SELECT 
    @totalLines as [Total lines available]
    , @linesToFetch as [Number of lines to fetch]
    , @availPages as [List of available pages for user to click]
    , @pageNumber as [Selected page to view (zero based)];


-- show the lines
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
OFFSET (@pageNumber * @linesToFetch) ROWS FETCH NEXT @linesToFetch ROWS ONLY;


