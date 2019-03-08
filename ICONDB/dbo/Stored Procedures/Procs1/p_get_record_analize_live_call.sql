-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_record_analize_live_call]
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
	from [leg_Icon1].[dbo].tblOnCalls  with(nolock)
	Where 	datediff(MINUTE,RecordDate,GETDATE()) <5
		    and errorCode =0 and duration is null
	if(@RecordID) > 0
		return;
	else
		begin
			select top 1  @RecordID= RecordID ,@FacilityID= FacilityID,@FromNo=FromNo,@ToNo=ToNo,@CallType= CallType,@billType=billType,
			@duration=duration ,@RecordDate =RecordDate, @PIN=PIN,@IPaddres= userName
			from [leg_Icon2].[dbo].tblOnCalls  with(nolock)
			Where 	datediff(MINUTE,RecordDate,GETDATE()) <5
					and errorCode =0 and duration is null
		end
	Select @ACP =DriveMap from  leg_Icon1.dbo.tblACPs with(nolock) where IpAddress = @IPaddres
END

