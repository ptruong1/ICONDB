-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION fn_determine_off_schedule_date
(
	 @facilityID  int,
	 @scheduleDate smalldatetime
)
RETURNS int
AS
BEGIN
	Declare @i int;
	select @i= count(*) from tblholiday with(nolock) where facilityID = @facilityID and holidayDate =@scheduleDate;
	Return @i;
END
