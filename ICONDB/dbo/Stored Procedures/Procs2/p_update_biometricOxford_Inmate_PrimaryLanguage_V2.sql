-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometricOxford_Inmate_PrimaryLanguage_V2]
@FacilityID int,
@InmateID varchar(12),
@Abbrev varchar(3) 

AS
BEGIN
	SET NOCOUNT ON;
		begin
			 update leg_Icon.dbo.tblInmate
				set [primaryLanguage] = (Select ACPSelectOpt from tblLanguages where Abbrev = @Abbrev)
				where FacilityID = @FacilityID  and InmateID =@InmateID and Status = 1
	
		 end
	
END

