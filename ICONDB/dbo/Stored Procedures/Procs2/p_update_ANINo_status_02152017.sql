-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_ANINo_status_02152017] 
	@FacilityID int,
	@ANINo varchar(10),
	@status tinyint,
	@UserName varchar(25),
	@StationID varchar(50),
	@UserIP varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare  @UserAction varchar(100),@ActTime datetime;
    SET  @UserAction =  'Update Phone No:' + @ANINo;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
      EXEC  INSERT_ActivityLogs3	@FacilityID ,7 ,@ActTime, 0,@UserName ,@UserIP,@UserName,@UserAction ;
	
    update leg_Icon.dbo.tblANIs 
		set [ANINoStatus] = @status 
			,[UserName] = @UserName
			,[modifyDate] = GETDATE()
			,[StationID] = @StationID
    where
		facilityID = @FacilityID and 
		ANINO = @ANINo 
END

