-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[p_get_form_email_Address]

@facilityID int,
@FormType smallint,
@ToAddress      varchar(500) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	set @ToAddress = ''
	If @FormType = 1
	 begin
		SELECT @ToAddress = (select [InmateKiteReceiveEmail] FROM [tblFacilityForms] where FacilityID = @facilityId)
	 end
	 else If @FormType = 2
	 begin
		SELECT @ToAddress = (select [MedicalKiteReceiveEmail] FROM [tblFacilityForms] where FacilityID = @facilityId)
	 end
	 else
	 If @FormType = 3
	 begin
		SELECT @ToAddress = (select [GrievanceReceiveEmail] FROM [tblFacilityForms] where FacilityID = @facilityId)
	 end
	
	

END

