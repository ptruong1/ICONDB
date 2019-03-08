-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_recreate_manual_pin_10102017]
	@facilityID int,
	@inmateID varchar(12),
	@currentPIN	varchar(12),
	@UserName varchar(20),
	@UserIP varchar(25),
	@NewPIN   varchar(12)
AS
BEGIN
		declare @UserAction varchar(100), @ActTime datetime;
		EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
		SET  @UserAction =  'Assign New PIN Manually: ' +  @InmateID + ' ; From CurrentPIN: ' + @currentPIN +  '; to New PIN:' + @NewPIN ;
		EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,@UserIP, @InmateID,@UserAction ;  
	If @currentPIN <> @NewPIN
	begin		 
		UPDATE tblInmate set PIN =@NewPIN where FacilityId =@facilityID and InmateID =@inmateID and PIN =@currentPIN;
		Return 0
	end
	else
	begin
		Return -1
	end
END


