use msdb
go
 
exec msdb.dbo.sp_send_dbmail
@profile_name='DBA Mail',
@recipients='dl.sac@flightcentre.com.au',
@subject='hello...test mail',
@body='hello world!'
go

-- test the MSSQL Operator
EXEC dbo.sp_notify_operator
   @profile_name = N'DBA Mail',
   @name = N'MSSQL DBA',
   @subject = N'Test Notification',
   @body = N'This is a test of notification via e-mail.'
go

