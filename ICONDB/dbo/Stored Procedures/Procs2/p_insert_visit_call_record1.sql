-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_insert_visit_call_record1]
@ExtID varchar(10) ,
@PIN varchar(12), 
@FacilityID int ,
@CallDate	char(8), 
@CallTime	char(6),  
@duration	int, 
@VisitType		tinyint, 
@VisitBilltype	tinyint, 
@RecordName		varchar(25),
@ServerIP	varchar(16)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    Declare @RecordDate datetime,@CallRevenue numeric(6,2), @timezone tinyint, @RateID		varchar(10),  
	@ConnectFee numeric(6,2),@MinuteCharge  numeric(6,2), @RecordDest varchar(100);
	select  @RecordDest= 'Y:\'+  ComputerName from tblACPs with(nolock) where IpAddress =@ServerIP;
	SET @ConnectFee=0;
	SET @MinuteCharge=0;
	SET @CallRevenue =0;
   
	select @timezone = timezone, @RateID= RateplanID from leg_Icon.dbo.tblfacility with(nolock) where facilityID= @facilityID;
	select  @MinuteCharge=PerMinCharge  , @ConnectFee=   ConnectFee from tblVisitRate with(nolock) where RateID = @RateID and VisitType =@VisitType;
	Set  @RecordDate = dateadd(hh, @timeZone,getdate() );
    SET @CallRevenue = @ConnectFee + (@duration/60) * @MinuteCharge;
    insert tblVisitCalls( ExtID, PIN , FacilityID , FolderDate, CallTime, RecordDate , duration , RateID,  ConnectFee ,MinuteCharge  ,
     CallRevenue, VisitType, VisitBilltype, RecordName,ServerIP) 
	values( @ExtID, @PIN , @FacilityID , @CallDate, @CallTime, @RecordDate , @duration , @RateID,  @ConnectFee ,@MinuteCharge  ,
     @CallRevenue, @VisitType, @VisitBilltype, @RecordName,@ServerIP);
	delete tblVisitPhoneOnline where recordID = @RecordName;
	delete tblVisitPhoneOnline 	where  RecordDate < dateadd(MINUTE , -MaxDuration, @RecordDate) 
	if(@@ERROR=0)
		select '1' as Success , @RecordDest as RecordDest  ;
	else
		select '-1' as Success , @RecordDest as RecordDest  ;
END

