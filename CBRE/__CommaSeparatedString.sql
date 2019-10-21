DECLARE @rowsToFetch int = 100;
DECLARE @totalRows int = 20;

WITH lv0 AS (SELECT 0 g UNION ALL SELECT 0)
	,lv1 AS (SELECT 0 g FROM lv0 a CROSS JOIN lv0 b) -- 4 rows
	,lv2 AS (SELECT 0 g FROM lv1 a CROSS JOIN lv1 b) -- 16 rows
	,lv3 AS (SELECT 0 g FROM lv2 a CROSS JOIN lv2 b) -- 256 rows
	,Tally (n) AS (SELECT 0 UNION ALL SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM lv3
)
SELECT STUFF(( 
	SELECT  ', ' + CAST(x.[n] as varchar(10))
    FROM ( 
			SELECT DISTINCT t.[n] 
			FROM Tally t
			WHERE t.[n] <= CASE WHEN @totalRows <= @rowsToFetch THEN 0 ELSE (@totalRows / @rowsToFetch)-1 END

		) x
		FOR XML PATH('')
	), 1, 2, '') as [List of available pages for user to click];
