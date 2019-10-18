WITH loginHistory as (
    SELECT 
        l.[UserName]
        , MAX(l.[LoginDate]) AS [Last_login]
        , MIN(l.[LoginDate]) AS [First_login]
    FROM [MRISystem].[dbo].[LoginHistory] l WITH (nolock)
    WHERE l.[Successful] = 'Y'
    GROUP BY l.[UserName]
)
, userClasses AS (
    SELECT 
        [UserName]
        , [FullName]
        , [UserClass]
        , [UserEmail]
    FROM [MRI_AUNZ].[dbo].[fn_UserClasses] ()  
)
, classUpdate AS (
    SELECT 
        C.[CLASS_ID] AS [UserName]
        , [MRI_AUNZ].dbo.MRIEntityClassLookup(C.[CLASS_ID]) as [classUpdate]
    FROM [MRI_AUNZ].[dbo].[MRICLDEF] C WITH (nolock)
    WHERE C.[TYPE] = 'U'
        AND c.[CLASS_ID] NOT IN (
            'ALF.GIULIANO','RDILEVA','MADHUKUMAR.MUNIREDDY','CHRIS.CALLANAN'
            ,'SDAY','TMALONEY','GEORGE.HUDD','Jasmine.Prasad','MCASTLE','CSHORT'
        )
)
SELECT 
    C.[CLASS_ID] AS [UserName]
    , U.[COMPLETE_NAME] AS [FullName]
    , CONVERT(VARCHAR(max), SUBSTRING(CONVERT(VARBINARY(max), C.[PROPERTIES]), 5, LEN(CONVERT(VARBINARY(max), C.[PROPERTIES])) - 5)) AS [Properties]
    , u.[EmailAddress] AS [UserEmail]
    , u.[Locked_TF] AS [Locked]
    , LD.[First_login]
    , LD.[Last_login]
    , cu.[classUpdate]
    , uc.[UserClass]
FROM [MRI_AUNZ].[dbo].[MRICLDEF] C WITH (nolock)
    INNER JOIN [MRISystem].[dbo].[MRI_Users] U WITH (nolock) ON U.[UserName] = C.[CLASS_ID]
    LEFT JOIN [MRI_AUNZ].[dbo].[WORKFLOWUSER] W WITH (nolock) ON C.[CLASS_ID] = W.[USERID]
    LEFT JOIN loginHistory LD ON U.[username] = LD.[UserName]
    LEFT JOIN classUpdate cu ON u.[UserName] = cu.[UserName]
    INNER JOIN userClasses uc ON u.[UserName] = uc.[UserName]
WHERE C.[TYPE] = 'U'
