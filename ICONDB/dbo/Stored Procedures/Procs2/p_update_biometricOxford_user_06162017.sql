-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometricOxford_user_06162017]
@FacilityID int,
@PIN varchar(12),
@BioStatus	tinyint,
@InmateStatus tinyint,
@Abbrev varchar(3) 

AS
BEGIN
	SET NOCOUNT ON;
	if @Abbrev <> ''
		begin
			 update leg_Icon.dbo.tblInmate
				set [BioRegister] = @BioStatus
				   ,[primaryLanguage] = (Select ACPSelectOpt from tblLanguages where Abbrev = @Abbrev)
				where FacilityID = @FacilityID  and PIN =@PIN
				and status = @InmateStatus;
	
		 end
	else
		Begin
			update leg_Icon.dbo.tblInmate
			set [BioRegister] = @BioStatus
	
			where FacilityID = @FacilityID  and PIN =@PIN
			and status = @InmateStatus;
		End

END


