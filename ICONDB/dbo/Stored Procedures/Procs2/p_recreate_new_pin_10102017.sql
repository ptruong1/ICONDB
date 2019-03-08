-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_recreate_new_pin_10102017]
	@facilityID int,
	@inmateID varchar(12),
	@currentPIN	varchar(12),
	@UserName varchar(20),
	@UserIP varchar(25),
	@NewAssignPIN   varchar(12)  OUTPUT
AS
BEGIN
	
	Declare @PIN varchar(4), @i int, @newPIN varchar(12) , @PINLen tinyint;
	SET @i =1;
	SET @PINLen = LEN(@currentPIN);
	While @i = 1
	 Begin
		if(@facilityID =607)
		 begin
			exec [dbo].[p_Create_new_PIN1] 	4,@PIN  OUTPUT;
			SET @newPIN = @inmateID + @PIN;
		 end
		else
		 begin 
			exec [dbo].[p_Create_new_PIN1] @PINLen,@newPIN  OUTPUT;
		 end
		if(@newPIN <> @currentPIN)
			SET @i =0;
	 End
	 SET @NewAssignPIN  =  @newPIN
	 
	UPDATE tblInmate set PIN =@newPIN where FacilityId =@facilityID and InmateID =@inmateID and PIN =@currentPIN;
	
	declare @UserAction varchar(100), @ActTime datetime;
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;
	
	SET  @UserAction =  'Assign New PIN Automatically: ' +  @InmateID + ' ; From CurrentPIN: ' + @currentPIN +  '; to New PIN:' + @NewAssignPIN ;
	EXEC  INSERT_ActivityLogs3	@FacilityID ,10,@ActTime  ,0,@UserName ,@UserIP, @InmateID,@UserAction ;  
END

