-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_inmate_to_unregister] 
	@facilityID int,
	@PIN	varchar(12) 
AS
BEGIN
	update leg_Icon.dbo.tblInmate set BioRegister=0 where FacilityId = @facilityID and PIN=@PIN
	
END

