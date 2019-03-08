-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_recreate_manual_pin]
	@facilityID int,
	@inmateID varchar(12),
	@currentPIN	varchar(12),
	@NewPIN   varchar(12)
AS
BEGIN
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


