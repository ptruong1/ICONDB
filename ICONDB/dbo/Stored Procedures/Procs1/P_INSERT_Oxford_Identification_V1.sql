


CREATE PROCEDURE [dbo].[P_INSERT_Oxford_Identification_V1]
(
	@UserID varchar(16),
	@ProfileID nvarchar(100),
	@ActionType smallint,
	@RemainEnrollments int,
	@BioInmateID varchar(12),
	@LanguageSelected varchar(6),
	@fileName varchar(50),
	@EnrolledFilePath varchar(75)
)
AS
	SET NOCOUNT OFF;
	

if @actionType = 4
begin
	DELETE FROM [dbo].[tblBioMetricProfileOxfordIdentification]
    WHERE  (UserID = @UserID and (BioInmateID = @BioInmateID or @BioInmateID = ''))
	 
end
else
if @actionType = 3
begin
	DELETE FROM [dbo].[tblBioMetricProfileOxfordIdentification]
	WHERE  	  (profileID = @profileId)
end

else
IF @userID in (SELECT userID FROM [dbo].[tblBioMetricProfileOxfordIdentification] WHERE UserID = @UserID)
	BEGIN
		UPDATE [dbo].[tblBioMetricProfileOxfordIdentification]
   SET 
      [ModifyDate] = Getdate()
   	  ,RemainEnrollments = @RemainEnrollments
	  ,BioInmateID = @BioInmateID
	  ,LanguageSelected = @LanguageSelected 
	  ,EnrolledFilePath = @EnrolledFilePath
		WHERE UserID = @UserID
   END
ELSE
	BEGIN
	declare  @facilityId int, @recordId as bigint, @fromNo varchar(12)
	set @facilityId = cast(LEFT(@UserId,CHARINDEX('-', @UserId)-1) as int)
	set @RecordId = cast(LEFT(@fileName,CHARINDEX('_', @fileName)-1) as bigint)
	set @fromNo = (select fromNo from tblCallsBilled where recordId = @recordId) 
	--and facilityId = @facilityId);
		INSERT INTO [dbo].[tblBioMetricProfileOxfordIdentification]
           ([UserID]
           ,[InputDate]
           ,[ModifyDate]
           ,[ProfileID]
		   ,RemainEnrollments
		   ,BioInmateID
		   ,LanguageSelected  
		   ,StationId
		   ,LocId
		   ,DivId
		   ,RecordId
		   ,EnrolledFilePath)
     VALUES
           (@userID
           ,Getdate()
           ,Getdate()
		   ,@ProfileID
		   ,@RemainEnrollments
		   ,@BioInmateID
	       ,@LanguageSelected 
		   ,(Select ANINo from tblANIs where ANINo = @fromNo)
		   ,(Select LocationId from tblANIs where ANINo = @fromNo)
		   ,(Select DivisionId from tblANIs where ANINo = @fromNo)
		   ,@RecordId
		   ,'')
	END




