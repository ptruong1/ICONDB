




CREATE PROCEDURE [dbo].[UPDATE_InmateRequestRecord_796]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@Reply varchar(2000),
	@ReplyName varchar(50),
	@ReplyDateTime datetime,
	@OfficerID tinyint,
	@ReferTo nvarchar(200),
    @Status tinyint
)
AS
	
SET NOCOUNT OFF;
UPDATE [leg_Icon].[dbo].[tblInmateRequestForm]
   SET 
        
      [Reply] = @Reply
      ,[ReplyName] = @ReplyName
      ,[ReplyDateTime] = @ReplyDateTime
	  ,OfficerID = @OfficerID
      ,ReferTo = @Referto
      ,[Status] = @Status
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

