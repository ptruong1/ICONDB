




Create PROCEDURE [dbo].[p_UPDATE_InmateRequestRecord]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@Reply varchar(2000),
	@ReplyName varchar(50),
	@ReplyDateTime datetime,
    @Status smallint
	)
AS
	
SET NOCOUNT OFF;
UPDATE [leg_Icon].[dbo].[tblInmateRequestForm]
   SET 
        
      [Reply] = @Reply
      ,[ReplyName] = @ReplyName
      ,[ReplyDateTime] = @ReplyDateTime
      ,[Status] = @Status
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

