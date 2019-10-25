DECLARE @PONUM varchar(20) = 'PO3587914_245113'
SELECT 
    'PO_Hdr' as [TABLE], [PurchaseOrderNumber], [DateRaised], [POStatus],poh.TotalCost
    , [Created], [Modified], [LastChangeTS], [SYNC_LASTUPDATE]
FROM [WSM_AUNZ].[dbo].[wsm_PurchaseOrder_Header] poh WITH (nolock)
WHERE [PurchaseOrderNumber] = @PONUM
ORDER BY poh.[PurchaseOrderNumber]

SELECT 'PO_Line' as [TABLE], [PurchaseOrderNumber],[ItemNumber],pol.TotalCost,pol.[UnitPrice]
    ,[Status],[HISTSTATUS],[HISTCHECKDT]
    ,[InvoiceNumber],[Created],[Modified],[LastChangedTS],[SYNC_LASTUPDATE]
FROM [WSM_AUNZ].[dbo].[wsm_PurchaseOrder_LineItem] pol WITH (nolock)
WHERE pol.[PurchaseOrderNumber] = @PONUM
ORDER BY pol.[PurchaseOrderNumber],pol.[ItemNumber]

SELECT *
FROM [WSM_AUNZ].[dbo].[wsm_PurchaseOrder_Log] pol WITH (nolock)
WHERE [PurchaseOrderNumber] = @PONUM
ORDER BY [LogID] DESC
