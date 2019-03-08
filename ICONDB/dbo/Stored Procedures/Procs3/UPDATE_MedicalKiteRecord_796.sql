




CREATE PROCEDURE [dbo].[UPDATE_MedicalKiteRecord_796]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@Copay  bit,
    @VisitedClinic bit,
	@ProviderName varchar(25),
    @NoteDate datetime,
	@StaffNote varchar(2000),
    @status tinyint
	
)
AS
	
SET NOCOUNT OFF;
UPDATE [leg_Icon].[dbo].[tblMedicalKiteForm]
   
   SET 
		 [Copay] = @Copay
		,[VisitedClinic] = @VisitedClinic
		,[ProviderName] = @ProviderName
		,[NoteDate] = @NoteDate
		,[StaffNote] = @StaffNote
        ,[Status] = @status
     
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

