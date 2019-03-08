﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[p_determine_Division_schedule]
(
	@facilityID int,
	@DivionID int,
	@LocalTime Datetime
)
RETURNS int
AS
BEGIN
	Declare  @day tinyint, @currentTime time(0), @fromTime varchar(5);
	SET @day = datepart(dw, @localtime);
	SET @currentTime = convert(time(0) ,@LocalTime);
	if(select count(*)  from tblDivisionTimeCallPeriod where facilityID = @facilityID and divisionID =@DivionID  and [day]=@day and fromtime = totime) > 0
		return 1;
	if ((select count(*)  from tblDivisionTimeCallPeriod where facilityID = @facilityID and divisionID =@DivionID  and [day]=@day and isnull(FromTime,'') <>'') >0 )
	 begin
		if (select count(*)  from tblDivisionTimeCallPeriod  where  facilityID = @facilityID and divisionID =@DivionID  and FromTime <>'' and convert(time(0) ,@LocalTime) >= convert (time(0),FromTime)  and convert(time(0) ,@LocalTime) <= convert (time(0),ToTime ) and day=@day ) >0
			return 1;
		else 
			return 0;
	
	 end
	return 1;
	
END
