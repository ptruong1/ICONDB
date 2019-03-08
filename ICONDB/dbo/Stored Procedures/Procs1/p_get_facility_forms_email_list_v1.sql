Create PROCEDURE [dbo].[p_get_facility_forms_email_list_v1]   
    @StatusID smallint,   
    @FacilityFormID int   
AS   
Begin
    SET NOCOUNT ON;  
	select InmateFormEmails, MedicalFormEmails, GrievanceFormEmails, LegalFormEmails, Program, Huber from tblFormstatus where StatusID = @StatusID and FacilityFormID = @FacilityFormID
End