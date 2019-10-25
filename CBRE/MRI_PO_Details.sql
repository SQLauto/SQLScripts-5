DECLARE @PONUM varchar(20) = 'PO3587914_245113'
SELECT 'POHD' as [TABLE],ph.[PONUM], ph.[ORDSTAT],cl.[CODEDESC] as [CL_STATUS],ph.[ENTERED],ph.[PRNTDATE]
    ,ph.[LASTDATE],ph.[USERID],ph.[APPROVED],ph.[APPRVDBY],ph.[APPROVE2],ph.[APPRV2BY]
    ,ph.[APPROVE3],ph.[APPRV3BY],ph.[APPROVE4],ph.[APPRV4BY],ph.[TOTAL]
FROM [MRI_AUNZ].[dbo].[POHD] ph WITH (nolock)
    LEFT JOIN [MRI_AUNZ].[dbo].[CODELIST] cl WITH (nolock) ON ph.[ORDSTAT] = cl.[CODEVAL] AND cl.[CODETYPE] = 'POSTATUS'
WHERE [PONUM] = @PONUM
ORDER BY ph.[PONUM]

SELECT 'PODT' as [TABLE],pd.[PONUM],pd.[LINENMBR], pd.[ORDSTAT],cl.[CODEDESC] as [CL_STATUS]
    ,pd.[LASTDATE],pd.[USERID],pd.[RECEIVED],pd.[INVOICED],pd.[ADDLDESC],[TOTCOST],[UNITCOST],[TAXCOST]
FROM [MRI_AUNZ].[dbo].[PODT] pd WITH (nolock)  	
    INNER JOIN [MRI_AUNZ].[dbo].[CODELIST] cl WITH (nolock) ON pd.[ORDSTAT] = cl.[CODEVAL] AND cl.[CODETYPE] = 'PODTSTATUS'
WHERE [PONUM]  = @PONUM
ORDER BY pd.[PONUM], pd.[LINENMBR]

SELECT 'INVC' as [TABLE],i.[PONUM],i.[VENDID],i.[INVOICE],i.[EXPPED],i.[INVCDATE]
    ,i.[LASTDATE],i.[USERID],i.[SECONDCHECKDATE],i.[SECONDCHECKBY],i.[INVCTOT],i.[PAIDAMT]
FROM [MRI_AUNZ].[dbo].[INVC] i WITH (nolock)
WHERE i.[PONUM]  = @PONUM
ORDER BY i.[PONUM]

SELECT 'HIST' as [TABLE],h.[PONUM], h.[POLINENMBR], h.[VENDID], h.[INVOICE], h.[EXPPED], h.[ITEM]
    , h.[DATECREATED],h.[USERCREATED], h.[STATUS],cl.[CODEDESC] as [CL_STATUS]
    , h.[ENTITYID], h.[LASTDATE],h.[USERID], h.[CHECKDT], h.[CHECKPD]
    , h.[PAYAUTHDATE], h.[PAYAUTHTIME],h.[PAYAUTHID], h.[ADDLDESC],h.[ITEMAMT], h.[TAXITEM]
FROM [MRI_AUNZ].[dbo].[HIST] h WITH (nolock)
    LEFT JOIN [MRI_AUNZ].[dbo].[CODELIST] cl WITH (nolock) ON h.[STATUS] = cl.[CODEVAL] AND cl.[CODETYPE] = 'INVCSTAT'
WHERE h.[PONUM]  = @PONUM
    AND h.[TAXITEM] = 'N'
ORDER BY h.[PONUM], h.[INVOICE], h.[ITEM], h.[EXPPED]