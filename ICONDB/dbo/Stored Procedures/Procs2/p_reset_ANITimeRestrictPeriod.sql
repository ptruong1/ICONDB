CREATE PROCEDURE [dbo].[p_reset_ANITimeRestrictPeriod]
(
	@FacilityID int,
	@ANINo char(10),
	@userName varchar(20)
	
)
AS
SET NOCOUNT OFF;
Update tblANIs Set   DayTimeRestrict = 0, UserName = @userName, modifyDate= getdate() where facilityID = @FacilityID and ANIno = @ANINo;

Delete from  [tblANITimeCallPeriod] where FacilityID = @FacilityID AND ANI = @ANINo ;

return 0 ;

