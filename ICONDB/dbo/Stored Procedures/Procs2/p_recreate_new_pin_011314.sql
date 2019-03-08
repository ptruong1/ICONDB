-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_recreate_new_pin_011314]
	@facilityID int,
	@inmateID varchar(12),
	@currentPIN	varchar(12)
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
	 
	UPDATE tblInmate set PIN =@newPIN where FacilityId =@facilityID and InmateID =@inmateID and PIN =@currentPIN;
	
END

