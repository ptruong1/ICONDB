




CREATE PROCEDURE [dbo].[UPDATE_InmateLegalRecord_796]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@TrackingNo int,
	@IDX varchar(12),
	@ReceivedBy varchar(50),
	@SendBy varchar(50),
	@Status tinyint
)
AS
	
SET NOCOUNT OFF;

 UPDATE [dbo].[tblInmateLegalRequest]
   
Set		[TrackingNo] = @TrackingNo
      ,[IDX] = @IDX 
       ,[ReceivedBy] = @ReceivedBy
       ,[SendBy] = @SendBy
      ,[Status] = @Status

 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

