-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_VisitPhone_Status] 
	@FacilityID int,
	@ExtID varchar(20),
	@RecordOpt varchar(1),
	@LimitTime int,
	@status tinyint,
	@PinRequired bit,
	@UserName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    update leg_Icon.dbo.tblVisitPhone
		set [Status] = @status
			,[RecordOpt] = @RecordOpt 
			,[LimitTime] = @LimitTime
			,[PINRequired] = @PINRequired
			,[UserName] = @UserName
			,[modifyDate] = GETDATE()
    where
		facilityID = @FacilityID and 
		ExtID = @ExtID 
END

