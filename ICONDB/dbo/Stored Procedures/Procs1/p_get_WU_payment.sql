
CREATE PROCEDURE [dbo].[p_get_WU_payment]
 AS
SET NOCOUNT ON
	DECLARE  @fname varchar(200), @str_rename  varchar(300),@Bulkfile varchar(300),  @next_found int, @str_len int , @str_move varchar(300), @GetImportDir  varchar(100)
	DECLARE  @CurrentImport  varchar(100), @bulkInsert  Nvarchar(1000) ,@error_return smallint, @fileCount  smallint ,@importDir   varchar(100), @ArchiveDir  varchar(100) ,  @year char(4) 
	SET @year =  CAST (datepart(yyyy,getdate()) as char(4))
	SET @fileCount = 0
	SET @fname = ''
	SET @importDir = 'C:\WU\Output\'
	SET @ArchiveDir ='C:\WU\Output\Archive\'
	CREATE TABLE #temp(tid int identity(1,1) ,t varchar(1000))
	SET @GetImportDir  = 'Dir ' +  @importDir  + 'LGX*  /w'
	INSERT INTO  #temp( t) EXEC  master.dbo.xp_cmdshell   @GetImportDir 
	SELECT  @fname =  IsNull(t,'') from #temp where tid =6
	
	SET @fname = ltrim(rtrim(@fname))
		
	
	
	print   @fname
	
	if(@fname <> 'File Not Found'  AND @fname <> ''  )
	  BEGIN
		SET @next_found  =0
		SET @next_found = charindex(' ' ,@fname, 1)
		IF(@next_found > 0) 
			SET  @fname   = ltrim(rtrim(LEFT (@fname, @next_found  )))
		
		if( @fname   <>'')
		  Begin
			SET @str_rename   =  'rename ' + @importDir +  @fname  + '  CurentImport.txt'
			EXEC  master.dbo.xp_cmdshell  @str_rename  
		 end	
		insert tblWUoutput (WUfileName) values ( @fname  )
	   END
	ELSE
	   Begin
		 SET @fileCount  = 0
	   End
/*
	If (select count(*)  from  tblWUpaymentTemp) > 0
	 Begin
		
		update  tblWUpaymentTemp Set CustAcctNo = replace(CustAcctNo, '"', '') where CustAcctNo like '%"%'
		update  tblWUpaymentTemp Set PaymentAmt = replace(PaymentAmt , '"', '') where PaymentAmt like '%"%'
		
		--Truncate table 	tblWUpaymentTemp
	 End
*/

