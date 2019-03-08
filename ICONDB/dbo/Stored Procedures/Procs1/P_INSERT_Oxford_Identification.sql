


CREATE PROCEDURE [dbo].[P_INSERT_Oxford_Identification]
(
	@UserID varchar(16),
	@ProfileID nvarchar(100),
	@ActionType smallint,
	@RemainEnrollments int,
	@BioInmateID varchar(12),
	@LanguageSelected varchar(6)
)
AS
	SET NOCOUNT OFF;
if @actionType = 4
begin
DELETE FROM [dbo].[tblBioMetricProfileOxfordIdentification]
      WHERE  UserID = @UserID and (BioInmateID = @BioInmateID or @BioInmateID = '')
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
		WHERE UserID = @UserID
   END
ELSE
	BEGIN
		INSERT INTO [dbo].[tblBioMetricProfileOxfordIdentification]
           ([UserID]
           ,[InputDate]
           ,[ModifyDate]
           ,[ProfileID]
		   ,RemainEnrollments
		   ,BioInmateID
		   ,LanguageSelected  )
     VALUES
           (@userID
           ,Getdate()
           ,Getdate()
		   ,@ProfileID
		   ,@RemainEnrollments
		   ,@BioInmateID
	       ,@LanguageSelected 
		   )
	END




