-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometric_user_10152015]
@FacilityID int,
@PIN varchar(12),
@BioStatus	tinyint 

AS
BEGIN
	SET NOCOUNT ON;
	begin
	 update leg_Icon.dbo.tblInmate
		set [BioRegister] = @BioStatus
		where FacilityID = @FacilityID  and PIN =@PIN
		
	 end
	

END

