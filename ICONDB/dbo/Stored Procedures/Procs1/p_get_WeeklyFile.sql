
CREATE PROCEDURE p_get_WeeklyFile
 AS
SET NOCOUNT ON
	DECLARE  @fname varchar(200), @str_rename  varchar(300),@Bulkfile varchar(300),  @next_found int, @str_len int , @str_move varchar(300), @GetImportDir  varchar(100)
	DECLARE  @CurrentImport  varchar(100), @bulkInsert  Nvarchar(1000) ,@error_return smallint, @fileCount  smallint ,@importDir   varchar(100), @ArchiveDir  varchar(100) ,  @year char(4) 
	SET @year =  CAST (datepart(yyyy,getdate()) as char(4))
	SET @fileCount = 0
	SET @fname = ''
	SET @importDir = '\\Iconweb\ftp\Lancaster\Weekly\'
	SET @ArchiveDir = '\\Iconweb\ftp\Lancaster\Weekly\Archive\'
	CREATE TABLE #temp(tid int identity(1,1) ,t varchar(1000))
	SET @GetImportDir  = 'Dir ' +  @importDir  + '*.txt  /w'
	INSERT INTO  #temp( t) EXEC  master.dbo.xp_cmdshell   @GetImportDir 
	SELECT  @fname =  IsNull(t,'') from #temp where tid =6
	
	SET @fname = ltrim(rtrim(@fname))
		
	
	
	if(@fname <> 'File Not Found'  AND @fname <> ''  )
	  BEGIN
			SET @next_found  =0
			SET @next_found = charindex(' ' ,@fname, 1)
			IF(@next_found > 0) 
				SET  @fname   = ltrim(rtrim(LEFT (@fname, @next_found  )))

			SET @str_rename   =  'rename ' + @importDir +  @fname  + '  CurentImport.txt'
			EXEC  master.dbo.xp_cmdshell  @str_rename  
			SET @CurrentImport  =  @importDir + 'CurentImport.txt'
	
			SET  @bulkInsert = N'BULK INSERT dbo.tblInmateTemp   FROM '''  +     @CurrentImport  +
				''' WITH(
						 DATAFILETYPE = ''Char'',
						 FIELDTERMINATOR ='','',
					 	ROWTERMINATOR = ''\n''
				)'
				
			EXEC (@bulkInsert )
			
			
			
			
			 
		
	   END
	
	update tblInmateTemp Set LastName = replace(LastName, '"', '') where LastName like '%"%'
	update tblInmateTemp  Set FirstName = replace(FirstName , '"', '') where FirstName like '%"%'
	
	Insert INTO tblInmate (InmateID,LastName, FirstName , FacilityID, PIN, status)   Select Pin, LastName, FirstName, 74, PIN, 1  from  tblInmateTemp   where PIN not in (select PIN from tblInmate where facilityID = 74)
	Insert INTO tblInmate (InmateID,LastName, FirstName , FacilityID, PIN, status)   Select Pin, LastName, FirstName, 75, PIN, 1  from  tblInmateTemp   where PIN not in (select PIN from tblInmate where facilityID = 75)
	--update tblInmate SET status =1,  modifyDate =getdate()    from   tblInmateTemp  where  tblInmate.PIN = tblInmateTemp.PIN  and facilityID =74
	--update tblInmate SET status =1 , modifyDate =getdate()   from   tblInmateTemp  where  tblInmate.PIN = tblInmateTemp.PIN  and facilityID =75
	Truncate table 	 tblInmateTemp
	If(@@error = 0) 
	Begin
		SET @str_move = 'move  ' + @CurrentImport  + '  ' +   @ArchiveDir 
		EXEC master.dbo.xp_cmdshell   @str_move
		SET @str_rename   = 'rename   ' + @ArchiveDir  + 'CurentImport.txt  ' + @fname +'.DONE'
		EXEC  master.dbo.xp_cmdshell  @str_rename
	End
