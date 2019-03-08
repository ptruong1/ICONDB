
CREATE PROCEDURE p_get_BookingFile_temp
 AS
SET NOCOUNT ON
	DECLARE  @fname varchar(200), @str_rename  varchar(300),@Bulkfile varchar(300),  @next_found int, @str_len int , @str_move varchar(300), @GetImportDir  varchar(100)
	DECLARE  @CurrentImport  varchar(100), @bulkInsert  Nvarchar(1000) ,@error_return smallint, @fileCount  smallint ,@importDir   varchar(100), @ArchiveDir  varchar(100) ,  @year char(4) 
	SET @year =  CAST (datepart(yyyy,getdate()) as char(4))
	SET @fileCount = 0
	SET @fname = ''
	SET @importDir = '\\Iconweb\ftp\Lancaster\Booking\'
	SET @ArchiveDir = '\\Iconweb\ftp\Lancaster\Booking\Archive\'
	CREATE TABLE #temp(tid int identity(1,1) ,t varchar(1000))
	SET @GetImportDir  = 'Dir ' +  @importDir  + '*.DONE /w'
	INSERT INTO  #temp( t) EXEC  master.dbo.xp_cmdshell   @GetImportDir 
	SELECT  @fname =  IsNull(t,'') from #temp where tid =6
	
	SET @fname = ltrim(rtrim(@fname))
		
	
	
	--print   @fname
	
	if(@fname <> 'File Not Found'  AND @fname <> ''  )
	  BEGIN
		SET @next_found  =0
		SET @next_found = charindex(' ' ,@fname, 1)
		IF(@next_found > 0) 
			SET  @fname   = ltrim(rtrim(LEFT (@fname, @next_found  )))
		
		WHILE( @fname   <>'')
		  Begin
			SET @str_rename   =  'rename ' + @importDir +  @fname  + '  CurentImport.txt'
			EXEC  master.dbo.xp_cmdshell  @str_rename  
			SET @CurrentImport  =  @importDir + 'CurentImport.txt'
	
			SET  @bulkInsert = N'BULK INSERT dbo.tblInmateTemp   FROM '''  +     @CurrentImport  +
				''' WITH(
						 DATAFILETYPE = ''char'',
						 FIELDTERMINATOR ='','',
					 	ROWTERMINATOR = ''\n''
				)'
			--select  @bulkInsert 
			EXEC (@bulkInsert )
			
			SET @str_move = 'move  ' + @CurrentImport  + '  ' +   @ArchiveDir 
			EXEC master.dbo.xp_cmdshell   @str_move
			SET @str_rename   = 'rename   ' + @ArchiveDir  + 'CurentImport.txt  ' + @fname +'.DONE'
			EXEC  master.dbo.xp_cmdshell  @str_rename
			
			IF(@next_found>0 )
			 Begin
				UPDATE   #temp  SET  t  =  Ltrim(Substring(t, @next_found, len(t)))  WHERE tid =6
				SELECT  @fname = IsNull(t,'') from #temp where tid =6
				SET @fname = ltrim(rtrim(@fname))
				SET @next_found = 0
				SET @next_found = charindex(' ' ,@fname, 1)
				IF(@next_found>0 )
					SET  @fname   = ltrim(rtrim(substring (@fname, 1,@next_found -1 )))
					
					
			 End
			else SET @fname =''
			 SET  @fileCount =  @fileCount + 1  
		  END
	   END
	ELSE
	   Begin
		 SET @fileCount  = 0
	   End
	If (select count(*)  from   tblInmateTemp ) > 0
	 Begin
		--update tblInmateTemp Set LastName = replace(LastName, '"', '') where LastName like '%"%'
		--update tblInmateTemp  Set FirstName = replace(FirstName , '"', '') where FirstName like '%"%'
		--update tblInmate SET status =1   from   tblInmateTemp  where  tblInmate.PIN = tblInmateTemp.PIN  and facilityID =74
		--update tblInmate SET status =1   from   tblInmateTemp  where  tblInmate.PIN = tblInmateTemp.PIN  and facilityID =75
		
		Insert tblInmate (inmateID,LastName, FirstName , FacilityID, PIN,status,  ModifyDate )   Select PIN, LastName, FirstName,74,  PIN ,1, getdate() from  tblInmateTemp   where PIN 
			not in (select PIN from tblInmate where facilityID = 74)

		Insert tblInmate (inmateID,LastName, FirstName , FacilityID, PIN,status,  ModifyDate )   Select PIN, LastName, FirstName,75,  PIN,1 , getdate() from  tblInmateTemp   where PIN 
			not in (select PIN from tblInmate where facilityID = 75)

		--Truncate table 	 tblInmateTemp
	 End
