-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--USE Leg_ICON_Dev
CREATE PROCEDURE [dbo].[p_export_Call_Detail_by_Facility]
@facilityID int	,
@Fromdate varchar(10),
@ToDate varchar(10)
AS
BEGIN

Declare @cmd  varchar(500) ,  @file_dir   varchar(200),  @FileName varchar(50);
SET @file_dir = 'C:\WU\';


	SET @FileName ='CDR' + CONVERT (varchar(8), getdate(), 112) +'.csv' ; 
	EXEC [172.77.10.10].Leg_ICON.dbo.[p_export_Call_by_Facility] @facilityID , @Fromdate , @ToDate;
	SET @cmd = 'bcp Leg_ICON.dbo.tblCallsTemp OUT  '  +  @file_dir  + @FileName  +     ' -t ";" -c   -S172.77.10.10  -Usa -PTianhmi11082001  ' ;
	--print @cmd 
	--EXEC ( @cmd )
	EXEC  master.dbo.xp_cmdshell   @cmd ;
	
	
		SET @cmd ='Copy C:\WU\'+ @FileName + '  \\172.77.40.10\SonomaFTP\' + @FileName + ' /y';
	--print @cmd ;
	EXEC  master.dbo.xp_cmdshell   @cmd ;
	--SET @cmd ='Del C:\WU\'+ @FileName ;
	--EXEC  master.dbo.xp_cmdshell   @cmd ;
	--truncate table TempInmate;
	delete [172.77.10.10].Leg_ICON.dbo.tblCallsTemp ;
	
	
	
return @@error

END

