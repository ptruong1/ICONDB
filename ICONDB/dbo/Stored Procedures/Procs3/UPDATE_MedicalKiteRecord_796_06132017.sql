




CREATE PROCEDURE [dbo].[UPDATE_MedicalKiteRecord_796_06132017]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@Copay  bit,
    @VisitedClinic bit,
	@NoteBy varchar(50),
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
		,[NoteBy] = @NoteBy
		,[NoteDate] = @NoteDate
		,[StaffNote] = @StaffNote
        ,[Status] = @status
     
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

