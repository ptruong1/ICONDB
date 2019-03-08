




CREATE PROCEDURE [dbo].[UPDATE_MedicalKiteRecord]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@Response varchar(2000),
    @ReviewedBy varchar(30),
    @ReviewedDate datetime,
    @StaffNote varchar(300),
    @NoteBy varchar(30),
    @NoteDate datetime,
    @MDClinic int,
    @Nurse int,
    @ChartReview int,
    @MentalHealth int,
    @status tinyint
)
AS
	
SET NOCOUNT OFF;
UPDATE [leg_Icon].[dbo].[tblMedicalKiteForm]
   SET 
       [Response] = @Response
      ,[ReviewedBy] = @ReviewedBy
      ,[ReviewedDate] = @ReviewedDate
      ,[StaffNote] = @StaffNote
      ,[NoteBy] = @NoteBy
      ,[NoteDate] = @NoteDate
      ,MDClinic = @MDClinic 
      ,Nurse = @Nurse
      ,ChartReview = @ChartReview
	  ,MentalHealth = @MentalHealth
      ,[status] = @status
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

