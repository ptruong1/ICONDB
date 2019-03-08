-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_biometric_Inmate_Status]
@FacilityID int,
@InmateID varchar(12),
@BioStatus	tinyint,
@Abbrev varchar(3) 

AS
BEGIN
	SET NOCOUNT ON;
	if @Abbrev <> ''
		begin
			 update leg_Icon.dbo.tblInmate
				set [BioRegister] = @BioStatus
				   ,[primaryLanguage] = (Select ACPSelectOpt from tblLanguages where Abbrev = @Abbrev)
				where FacilityID = @FacilityID  and InmateID =@InmateID
	
		 end
	else
		Begin
			update leg_Icon.dbo.tblInmate
			set [BioRegister] = @BioStatus
	
			where FacilityID = @FacilityID  and InmateID =@InmateID

		End

END

