-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_recreate_new_pin]
	@faciliyID int,
	@inmateID varchar(12),
	@currentPIN	varchar(12)
AS
BEGIN
	Declare @PIN varchar(4), @i int, @newPIN varchar(12)
	SET @i =1
	While @i = 1
	 Begin
		exec [dbo].[p_Create_new_PIN1] 	4,@PIN  OUTPUT
		SET @newPIN = @inmateID + @PIN
		if(@newPIN <> @currentPIN)
			SET @i =0
	 End
	UPDATE tblInmate set PIN =@newPIN where FacilityId =@faciliyID and InmateID =@inmateID and PIN =@currentPIN
END

