-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometric_user]
@FacilityID int,
@InmateID	varchar(12),
@UserStatus	tinyint 

AS
BEGIN
	SET NOCOUNT ON;
	begin
	 update leg_Icon.dbo.tblInmate
		set [BioRegister] = 1 
		where FacilityID = @FacilityID  and InmateID =@InmateID ;
		
	 end
	

END

