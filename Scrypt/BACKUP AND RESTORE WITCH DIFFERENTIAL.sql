BACKUP DATABASE [AdventureWorks] 
TO  DISK = N'D:\jcmoralesT\BACKUP\AdventureWorks20211005.bak' 
WITH NOFORMAT, NOINIT,  NAME = N'AdventureWorks-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10;


BACKUP DATABASE [AdventureWorks] 
TO  DISK = N'D:\jcmoralesT\BACKUP\AdventureWorks20211005DIF.bak' 
WITH  DIFFERENTIAL , NOFORMAT, NOINIT,  NAME = N'AdventureWorks-Differential Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10

RESTORE DATABASE [AW2021] 
FROM  DISK = N'D:\jcmoralesT\BACKUP\AdventureWorks20211005.bak' 
WITH  FILE = 1,  
MOVE N'AdventureWorks2017' TO N'D:\jcmoralesT\DATA\AW2021_Data.mdf', 
MOVE N'AdventureWorks2017_Log' TO N'D:\jcmoralesT\DATA\AW2021_Log.ldf',  
NORECOVERY,  NOUNLOAD,  STATS = 5

RESTORE DATABASE [AW2021] 
FROM  DISK = N'D:\jcmoralesT\BACKUP\AdventureWorks20211005DIF.bak' 
WITH  FILE = 1,  
MOVE N'AdventureWorks2017' TO N'D:\jcmoralesT\DATA\AW2021_Data.mdf',  
MOVE N'AdventureWorks2017_Log' TO N'D:\jcmoralesT\DATA\AW2021_Log.ldf',  
NOUNLOAD,  STATS = 5

--RESTORE FILELISTONLY FROM AdventureWorks
--GO