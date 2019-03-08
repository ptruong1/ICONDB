-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_record_analize_thirdParty]
	@facilityID int  OUTPUT,
	@RecordID	bigint OUTPUT, 
	@FromNo			char(10) OUTPUT,
	@ToNo		varchar(18) OUTPUT, 
	@RecordDate	Datetime	OUTPUT,
	@CallType	varchar(2)	OUTPUT,
	@billType	varchar(2)	OUTPUT,
	@duration	int			OUTPUT, 
	@PIN		varchar(12)	OUTPUT, 
	@ACP		varchar(20)	OUTPUT
AS
BEGIN
	Declare @IPaddres	varchar(18)		
	SET @RecordDate ='1/1/2000'	
	--select 'TEST'		
	select top 1  @RecordID= RecordID ,@FacilityID= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
	@duration=duration ,@RecordDate =RecordDate, @PIN=PIN,@IPaddres= userName
	from [leg_Icon].[dbo].tblCallsbilled with(nolock)
	Where 	datediff(d,RecordDate,GETDATE()) <2 and 
		--duration >300 and 
		InRecordFile is null and userName in  ('172.20.30.11','172.20.30.12','172.20.30.13','172.20.30.14','172.20.30.15' ) -- for now
	order by RecordDate desc
	if(@RecordID) > 0
		begin
			update [leg_Icon].[dbo].tblCallsbilled set InRecordFile='P' where RecordID=@RecordID
		end
	Select @ACP =DriveMap from  leg_Icon.dbo.tblACPs with(nolock) where IpAddress = @IPaddres
END

