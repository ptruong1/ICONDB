




CREATE PROCEDURE [dbo].[p_UPDATE_GrievanceRecord_798]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@ComplaintCheckBox smallint,
	@GrievanceCheckBox smallint,
	@OfficerResponse varchar(2000),
	@OfficerName varchar(50),
    @OfficerSignature varchar(50),
	@OfficerResponseTime datetime,
    @Status tinyint
)
AS
	
SET NOCOUNT OFF;

   UPDATE [tblGrievanceForm]
   SET ComplaintCheckBox = @ComplaintCheckBox
      ,GrievanceCheckBox = @GrievanceCheckBox
	  ,OfficerResponse = @OfficerResponse
	  ,[OfficerName] = @OfficerSignature
      ,[OfficerSignature] = @OfficerSignature
	  ,[OfficerResponseTime] = @OfficerResponseTime
      ,[Status] = @Status
      
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

