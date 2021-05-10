﻿/*
Script to restore the LATEST full and differential backups from a SQL Server 2008 R2 backup device.
If this script is to be used for restoring a SQL Server 2005 database, please remove "CompressedBackupSize" from the temporary table
*/
----------------------------------------------------------------------------
--1. Create a temporary table for holding backup header information
----------------------------------------------------------------------------


IF OBJECT_ID('TempDB..#RestoreHeaderOnlyData') IS NOT NULL
DROP TABLE #RestoreHeaderOnlyData
GO
CREATE TABLE #RestoreHeaderOnlyData( 
BackupName NVARCHAR(128) 
,BackupDescription NVARCHAR(255) 
,BackupType smallint 
,ExpirationDate datetime 
,Compressed tinyint 
,Position smallint 
,DeviceType tinyint 
,UserName NVARCHAR(128) 
,ServerName NVARCHAR(128) 
,DatabaseName NVARCHAR(128) 
,DatabaseVersion INT 
,DatabaseCreationDate datetime 
,BackupSize numeric(20,0) 
,FirstLSN numeric(25,0) 
,LastLSN numeric(25,0) 
,CheckpointLSN numeric(25,0) 
,DatabaseBackupLSN numeric(25,0) 
,BackupStartDate datetime 
,BackupFinishDate datetime 
,SortOrder smallint 
,CodePage smallint 
,UnicodeLocaleId INT 
,UnicodeComparisonStyle INT 
,CompatibilityLevel tinyint 
,SoftwareVendorId INT 
,SoftwareVersionMajor INT 
,SoftwareVersionMinor INT 
,SoftwareVersionBuild INT 
,MachineName NVARCHAR(128) 
,Flags INT 
,BindingID uniqueidentifier 
,RecoveryForkID uniqueidentifier 
,Collation NVARCHAR(128) 
,FamilyGUID uniqueidentifier 
,HasBulkLoggedData INT 
,IsSnapshot INT 
,IsReadOnly INT 
,IsSingleUser INT 
,HasBackupChecksums INT 
,IsDamaged INT 
,BeginsLogChain INT 
,HasIncompleteMetaData INT 
,IsForceOffline INT 
,IsCopyOnly INT 
,FirstRecoveryForkID uniqueidentifier 
,ForkPointLSN numeric(25,0) 
,RecoveryModel NVARCHAR(128) 
,DifferentialBaseLSN numeric(25,0) 
,DifferentialBaseGUID uniqueidentifier 
,BackupTypeDescription NVARCHAR(128) 
,BackupSetGUID uniqueidentifier 
,CompressedBackupSize BIGINT
,Containment INT
,KeyAlgorithm varchar(500)
,EncryptorThumbprint varchar(500)
,EncryptorType varchar(500)
) 

----------------------------------------------------------------------------
--2. Collect header information FROM the backup device into a temporary table
----------------------------------------------------------------------------
INSERT INTO #RestoreHeaderOnlyData 
EXEC('RESTORE HEADERONLY FROM AdventureWorksData') 

----------------------------------------------------------------------------
--3. Complete database restore from the latest FULL backup; 
----------------------------------------------------------------------------
--NORECOVERY is specified so that roll back not occur. This allows additional backups to be restored. 
DECLARE @File smallint
SELECT @File = MAX(Position) 
FROM #RestoreHeaderOnlyData 
WHERE BackupName = 'AdventureWorks – Full Backup 20211005_052311' 

RESTORE DATABASE AdventureWorks20211005_052311 
FROM AdventureWorks 
WITH FILE = @File, 
    MOVE N'AdventureWorks' TO N'E:\BD II PROMECYS\DATABASES\DATA\AdventureWorks20211005_052311_Data.mdf', 
	MOVE N'AdventureWorks_2' TO N'E:\BD II PROMECYS\DATABASES\DATA\AdventureWorks20211005_052311_2.mdf', 
	MOVE N'AdventureWorks_3' TO N'E:\BD II PROMECYS\DATABASES\DATA\AdventureWorks20211005_052311_3.mdf', 
	MOVE N'AdventureWorks_4' TO N'E:\BD II PROMECYS\DATABASES\DATA\AdventureWorks20211005_052311_4.mdf', 
	MOVE N'AdventureWorks_5' TO N'E:\BD II PROMECYS\DATABASES\DATA\AdventureWorks20211005_052311_5.mdf', 
    MOVE N'AdventureWorks_Log_1' TO N'E:\BD II PROMECYS\DATABASES\LOG\AdventureWorks20211005_052311_Log_1.ldf', 
	MOVE N'AdventureWorks_Log_2' TO N'E:\BD II PROMECYS\DATABASES\LOG\AdventureWorks20211005_052311_Log_2.ldf', 
NOUNLOAD, REPLACE, STATS = 10
GO


----------------------------------------------------------------------------
--4. Next: Restore the latest differential database backup
----------------------------------------------------------------------------
--If log backups are to be restored, specify NORECOVERY in this step also
--Then use RESTORE LOG to restore logs in the correct sequence 
--Specify RECOVERY in the last RESTORE LOG statement

--DECLARE @File smallint
--SELECT @File = MAX(Position) 
--FROM #RestoreHeaderOnlyData 
--WHERE DatabaseName = 'SomeDatabase' 
--    AND BackupTypeDescription = 'Database Differential'
    
--RESTORE DATABASE [SomeDatabase] FROM DISK = N'\\servername\foldername\BackupDeviceName.bak'
--    WITH FILE = @File, 
--    MOVE N'SomeDatabase' TO N'E:\BD II PROMECYS\DATABASES\DATA\SomeDatabase.mdf', 
--    MOVE N'SomeDatabase_log' TO N'E:\BD II PROMECYS\DATABASES\LOG\SomeDatabase.ldf', 
--NOUNLOAD, REPLACE, STATS = 10, RECOVERY