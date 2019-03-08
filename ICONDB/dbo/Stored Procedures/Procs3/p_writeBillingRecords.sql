

CREATE PROCEDURE [dbo].[p_writeBillingRecords]
 @FileName  varchar(30),
@connectDate varchar(6) 
 AS
SET NOCOUNT ON
Declare @cmd  varchar(300) ,  @file_dir   varchar(200)
SET @file_dir = 'C:\CDR\'
If (select count(*) from ##tblBICTemp) > 0 
Begin
	SET @FileName =@FileName   +  @connectDate  +  '.txt'  -- convert(varchar(6),convert(smalldatetime,getdate()),12)  + '.txt'
	SET  @cmd =  'bcp ##tblBICtemp  out  '  +  @file_dir  + @FileName  +     '  -t   -c  -S172.77.10.10  -Usa -PTianhmi11082001   '
	--select @cmd 
	
	EXEC  master.dbo.xp_cmdshell   @cmd

	--SET @cmd ='Copy C:\CDR\'+ @FileName + '  \\172.77.40.10\PraeseFTP\' + @FileName + ' /y';
	----print @cmd ;
	--EXEC  master.dbo.xp_cmdshell   @cmd ;
	
End
return @@error
