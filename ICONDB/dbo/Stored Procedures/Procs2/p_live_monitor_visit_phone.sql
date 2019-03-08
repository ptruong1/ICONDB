-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_live_monitor_visit_phone]
@FacilityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @timezone smallint;
	SET @timezone =0;
    select @timezone = timezone from tblfacility with(nolock) where facilityID= @facilityID;
	select RecordID, Ext as StationID, RecordDate as VisitTime  from tblVisitPhoneOnline with(nolock) 
	where FacilityID = @facilityID
	and RecordOpt ='Y' and RecordDate > dateadd(MINUTE , -MaxDuration, getdate()) 
END

