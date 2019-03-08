
CREATE PROCEDURE [dbo].[p_writeWURecordToFile]

 AS
SET NOCOUNT ON
Declare @cmd  varchar(4000) ,  @file_dir   varchar(200),  @FileName  varchar(14)

Set  @file_dir   = 'D:\WU\Input\'

If (select count(*) from tempWU ) > 1 
Begin
	exec p_create_wu_inputFileName  @filename    OUTPUT

	SET @FileName = @FileName  + '.txt' 
	SET  @cmd =  'bcp "select RecordType, PSCNo , ClientID, CustAcctNo , FirstName , LastName, Address , City , State, Zip,Country ,Phone, ProcessType, IssueCard from  leg_Icon..tempWU      order by CustSeqNo  "  queryout  "'  +  @file_dir  + @FileName  +     '"   -t  -c  -SLIC-DATA\BIGDADDYICON   -UICONAccess -Pmylegacy@123   '
	--EXEC @cmd
	EXEC  master.dbo.xp_cmdshell   @cmd
	SET  @cmd  = 'Rename ' +  @file_dir  + @FileName + ' ' + left ( @FileName,8)
	EXEC  master.dbo.xp_cmdshell   @cmd
	
End
return @@error
