-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_available_duration] 
	@ANI char(10),
	@FacilityID int,
	@LocalTime  datetime,
	@CallLimit  smallint OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	Declare @t time(0), @TimeLeft smallint, @day tinyint;
	Set  @t = CAST (@LocalTime as time(0));
	SET  @day = Datepart(DW,@LocalTime);
	SET @TimeLeft  =0;
	select @TimeLeft = datediff(MINUTE, @t , toTime)   from tblFacilityTimeCallPeriod where facilityID =@facilityID and [day] =@day  and ToTime >  @t
	If(@TimeLeft > 0 and @TimeLeft <@CallLimit )
		SET @CallLimit = @TimeLeft;
END

