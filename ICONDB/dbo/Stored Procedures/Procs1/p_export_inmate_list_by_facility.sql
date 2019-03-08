-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--USE Leg_ICON_Dev
CREATE PROCEDURE [dbo].[p_export_inmate_list_by_facility]
@facilityID int	
AS
BEGIN

Declare @cmd  varchar(500) ,  @file_dir   varchar(200),  @FileName varchar(50);
SET @file_dir = 'C:\WU\';


	SET @FileName ='ActiveRosterDateTime' + replace ( convert(varchar(25),getdate(),110),'-','') +  replace ( convert(varchar(25),getdate(),108),':','') +'.csv' ; -- convert(varchar(6),convert(smalldatetime,getdate()),12)  + '.txt'
	Insert [172.77.10.10].Leg_ICON.dbo.TempInmate
	select  '' as BookingID, InmateID,FirstName ,isnull(MidName,'') ,LastName , '' as Suffix,0 as Race, isnull(Sex,'M'),isnull(dob,'') ,CONVERT(varchar(12),inputdate,101) ,'' as Loc1, '' as Loc2, '' as Loc3,  '' as Loc4,'' as Privil,
	'' as SSN, '' as Addr1, '' As Addr2,'' as Cit, '' as State, '' Zip  from  [172.77.10.10].Leg_ICON.dbo.tblInmate where  FacilityId =670 and Status=1;
	SET @cmd = 'bcp Leg_ICON.dbo.TempInmate OUT  '  +  @file_dir  + @FileName  +     ' -t ";" -c   -S172.77.10.10  -Usa -PTianhmi11082001  ' ;
	--print @cmd 
	--EXEC ( @cmd )
	EXEC  master.dbo.xp_cmdshell   @cmd ;
	
	
	--SET @file_dir = '\\M:\';


	--SET @FileName ='ActiveRosterDateTime' + replace ( convert(varchar(25),getdate(),110),'-','') +  replace ( convert(varchar(25),getdate(),108),':','') +'.csv' ; -- convert(varchar(6),convert(smalldatetime,getdate()),12)  + '.txt'
	--Insert TempInmate
	--select  '' as BookingID, InmateID,FirstName ,isnull(MidName,'') ,LastName , '' as Suffix,0 as Race, isnull(Sex,'M'),isnull(dob,'') ,CONVERT(varchar(12),inputdate,101) ,'' as Loc1, '' as Loc2, '' as Loc3,  '' as Loc4,'' as Privil,
	--'' as SSN, '' as Addr1, '' As Addr2,'' as Cit, '' as State, '' Zip  from tblInmate where  FacilityId =670 and Status=1;
	--SET @cmd = 'bcp  leg_Icon.dbo.TempInmate OUT  '  +  @file_dir  + @FileName  +     ' -t ";" -c   -S172.77.10.10\BigdaddyICON  -Usa -PTianhmi11082001   ' ;
	--print @cmd 
	--EXEC ( @cmd )
	SET @cmd ='Copy C:\WU\'+ @FileName + '  \\172.77.40.10\MontgomeryFTP\' + @FileName + ' /y';
	--print @cmd ;
	EXEC  master.dbo.xp_cmdshell   @cmd ;
	SET @cmd ='Del C:\WU\'+ @FileName ;
	EXEC  master.dbo.xp_cmdshell   @cmd ;
	--truncate table TempInmate;
	delete [172.77.10.10].Leg_ICON.dbo.TempInmate;
	
	
	
return @@error

END

