-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_facility_visit_option]
@facilityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select VisitOpt, VisitRegReq, VisitIDReq, VisitPicReq , HourBeforeCancel, MaxDuration  from tblVisitFacilityConfig with(nolock) where FacilityID=@facilityID;
  
END

