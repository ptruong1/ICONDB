CREATE PROCEDURE [dbo].[p_get_facility_forms_email_list]   
    @StatusID smallint,   
    @FacilityFormID int   
AS   
Begin
    SET NOCOUNT ON;  
	select InmateFormEmails, MedicalFormEmails, GrievanceFormEmails, LegalFormEmails from tblFormstatus where StatusID = @StatusID and FacilityFormID = @FacilityFormID
End