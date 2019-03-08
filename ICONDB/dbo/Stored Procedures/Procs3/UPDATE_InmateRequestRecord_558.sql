




CREATE PROCEDURE [dbo].[UPDATE_InmateRequestRecord_558]
(
	@FacilityId int,
	@formID int,
	@InmateID Varchar(12),
	@Reply varchar(2000),
	@ReplyName varchar(50),
	@ReplyDateTime datetime,
    @Status tinyint,
	@FormType tinyint
)
AS
	
SET NOCOUNT OFF;
UPDATE [tblInmateRequestForm]
   SET 
        
      [Reply] = @Reply
      ,[ReplyName] = @ReplyName
      ,[ReplyDateTime] = @ReplyDateTime
      ,[Status] = @Status
	  ,[FormType] = @Formtype
 WHERE FacilityID = @FacilityId and InmateID = @inmateID and FormID = @FormID

