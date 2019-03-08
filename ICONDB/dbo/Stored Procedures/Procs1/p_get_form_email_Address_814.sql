-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[p_get_form_email_Address_814]

@facilityID int,
@FormType smallint,
@StatusId int,
@ToAddress      varchar(500) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	set @ToAddress = ''
	If @FormType = 1
	 begin
		SELECT @ToAddress = (select [InmateFormEmails] FROM [tblFormStatus] where FacilityFormID = @facilityId and StatusId = @StatusId)
	 end
	 else If @FormType = 2
	 begin
		SELECT @ToAddress = (select [MedicalFormEmails] FROM [tblFormStatus] where FacilityFormID = @facilityId and StatusId = @StatusId)
	 end
	 else
	 If @FormType = 3
	 begin
		SELECT @ToAddress = (select [GrievanceFormEmails] FROM [tblFormStatus] where FacilityFormID = @facilityId and StatusId = @StatusId)
	 end
	
	

END

