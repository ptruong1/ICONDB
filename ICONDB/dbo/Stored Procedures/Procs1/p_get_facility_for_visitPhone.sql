-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facility_for_visitPhone]
@ExtID	varchar(10)	
AS
BEGIN
	Declare @FacilityID int ,@RecordOpt char(1), @PinRequired tinyint , @LimitTime smallint, @timezone tinyint,@localtime datetime,@day int, @h int, @IDRequired tinyint;
	Declare @CallDate char(8), @Calltime varchar(6), @s int, @m int, @strh char(2), @strm char(2), @strs char(2),@RecordName varchar(30) ;
	SET @FacilityID=0;
	SET @RecordOpt='Y';
	SET @PinRequired =0;
	SET @LimitTime =15;
	SET @timezone =0;
	SET  @IDRequired =0;
	SELECT  @FacilityID=  FacilityID ,@RecordOpt=isnull(RecordOpt,'Y'),@PinRequired= isnull(PinRequired,0) ,@LimitTime= isnull(LimitTime,15), @IDRequired = isnull(IDRequired,0) FROM [leg_Icon].[dbo].tblVisitPhone  with(nolock) where ExtID = @ExtID;
	
	select @timezone = timezone from tblfacility with(nolock) where facilityID= @facilityID;
	
	Set  @localtime = dateadd(hh, @timeZone,getdate() );
	SET @day = datepart(dw, @localtime);
	SET @h = datepart(hh, @localtime);
	if(@h <10)
		SET  @strh = '0' + CAST(@h as CHAR(1));
	else
		SET  @strh =  CAST(@h as CHAR(2))	;
	SET @m =  datepart(mi, @localtime)
	if(@m <10)
		SET  @strm = '0' + CAST(@m as CHAR(1));
	else
		SET  @strm =  CAST(@m as CHAR(2));
		
	SET @s = DATEPART(ss, @localtime);
	if(@s <10)
		SET  @strs = '0' + CAST(@s as CHAR(1));
	else
		SET  @strs =  CAST(@s as CHAR(2))
	SET @CallDate = CONVERT(char(10),@localtime,112);
	SET @Calltime = @strh + @strm + @strs;
	SET @RecordName = @CallDate + '_' + @Calltime + '_' + @ExtID;

	if(@FacilityID >0)
	 begin
		select '1' as Allow , @CallDate as CallDate, @Calltime as CallTime, @FacilityID as  FacilityID ,@RecordOpt as RecordOpt,@PinRequired as  PinRequired ,@LimitTime as LimitTime,@RecordName as RecordName, @IDRequired  as IDRequired;
	    if(select count(ext) from tblVisitPhoneOnline with(nolock) where FacilityID =@FacilityID and ext= @ExtID) =0
			Insert tblVisitPhoneOnline(FacilityID, Ext, RecordDate, RecordOpt, MaxDuration, RecordID) values (@facilityID, @ExtID, @localtime,@RecordOpt,@LimitTime, @RecordName);
		else
			update tblVisitPhoneOnline set RecordDate= @localtime, RecordOpt= @RecordOpt, MaxDuration= @LimitTime, RecordID= @RecordName where FacilityID =@FacilityID and ext= @ExtID;
	 end
	else
		select '0' as Allow , @CallDate as CallDate, @Calltime as CallTime, @FacilityID as  FacilityID ,@RecordOpt as RecordOpt,@PinRequired as  PinRequired ,@LimitTime as LimitTime, @RecordName as RecordName,  @IDRequired  as IDRequired;
	
END

