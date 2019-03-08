

CREATE PROCEDURE [dbo].[p_writeBSGRecords]
@Connectdate char(6)
 AS
SET NOCOUNT ON
Declare @cmd  varchar(300) ,  @file_dir   varchar(200),  @FileName  varchar(30)
SET @file_dir ='C:\BillingFiles\'
SET @filename = 'ICONbilledBSG'
If (select count(*) from ##tblTBRTemp) > 0 
Begin
	SET @FileName =@FileName   +  @Connectdate  +  '.txt' --  convert(varchar(6),convert(smalldatetime,getdate()),12)  + '.txt'
	SET  @cmd =  'bcp ##tblTBRtemp  out  '  +  @file_dir  + @FileName  +     '  -t   -c  -SICONDB  -Usa -Pmylegacy   '
	--select @cmd 
	
	EXEC  master.dbo.xp_cmdshell   @cmd
	
End
return @@error

