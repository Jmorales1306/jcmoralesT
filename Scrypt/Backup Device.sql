USE master;  
GO

EXEC sp_addumpdevice 'disk', 'AdventureWorks',   
'D:\jcmoralesT\BACKUP\AdventureWorks2019.bak';  
GO

BACKUP DATABASE AdventureWorks   
 TO AdventureWorks  
   WITH FORMAT, INIT, NAME = N'AdventureWorks – Full Backup' ;  
GO  

DECLARE @BackupName VARCHAR(100)
SET @BackupName = N'AdventureWorks – Full Backup ' + FORMAT(GETDATE(),'yyyyMMdd_hhmmss');

BACKUP DATABASE AdventureWorks
TO AdventureWorks
WITH NOFORMAT, NOINIT, NAME = @BackupName,
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

RESTORE FILELISTONLY FROM AdventureWorks
GO
RESTORE HEADERONLY FROM AdventureWorks
GO

SELECT      *
FROM        sys.backup_devices
GO

--EXEC sp_dropdevice 'AdventureWorks', 'delfile' ;  
--GO 