﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_VisitPhone_Status02152017] 
	@FacilityID int,
	@ExtID varchar(20),
	@RecordOpt varchar(1),
	@LimitTime int,
	@status tinyint,
	@PinRequired bit,
	@UserName varchar(25),
	@USerIP varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare  @UserAction varchar(100),@ActTime datetime;
    SET  @UserAction =  'Update Phone Visit:' + @ExtID;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
      EXEC  INSERT_ActivityLogs3	@FacilityID ,7 ,@ActTime, 0,@UserName ,@UserIP,@UserName,@UserAction ;
      
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

