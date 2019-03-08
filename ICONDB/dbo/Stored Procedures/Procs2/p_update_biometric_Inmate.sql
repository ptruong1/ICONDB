-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometric_Inmate]
@FacilityID int,
@InmateID varchar(12),
@BioStatus	tinyint 

AS
BEGIN
	SET NOCOUNT ON;
	begin
	 update leg_Icon.dbo.tblInmate
		set [BioRegister] = @BioStatus
		where FacilityID = @FacilityID  and InmateID =@InmateID
		and status = 1;
	 end
	

END

