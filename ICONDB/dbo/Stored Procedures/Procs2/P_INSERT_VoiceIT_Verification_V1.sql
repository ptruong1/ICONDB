


CREATE PROCEDURE [dbo].[P_INSERT_VoiceIT_Verification_V1]
		   (@UserEmail varchar(50)
           ,@password varchar(50)
           ,@UserID varchar(16)
           ,@FirstName varchar(16)
           ,@LastName varchar(16)
           ,@Phone1 varchar(10)
           ,@Phone2 varchar(10)
           ,@Phone3 varchar(16)
           ,@RemainEnrollments int
           ,@ContentLanguage varchar(12)
		   ,@ActionType int
		   ,@LanguageSelected varchar(6))
AS
	SET NOCOUNT OFF;
if @actionType = 4
begin
DELETE FROM [dbo].[tblBioMetricProfileVoiceITVerification]
      WHERE  UserEmail = @UserEmail
end
else
IF @userEmail in (SELECT userEmail FROM [dbo].[tblBioMetricProfileVoiceITVerification] WHERE UserEmail = @UserEmail)
	BEGIN
		UPDATE [dbo].[tblBioMetricProfileVoiceITVerification]
   SET 
      [ModifyDate] = Getdate()
	  ,ContentLanguage = @ContentLanguage
      ,RemainEnrollments = @RemainEnrollments
		WHERE UserEmail = @UserEmail
   END
ELSE
	BEGIN   
	INSERT INTO [dbo].[tblBioMetricProfileVoiceITVerification]
           ([UserEmail]
           ,[password]
           ,[UserID]
           ,[FirstName]
           ,[LastName]
           ,[Phone1]
           ,[Phone2]
           ,[Phone3]
           ,[InputDate]
           ,[ModifyDate]
           ,[RemainEnrollments]
           ,[ContentLanguage]
		   ,LanguageSelected)
     VALUES
           (@UserEmail
           ,@password
           ,@UserID
           ,@FirstName
           ,@LastName
           ,@Phone1
           ,@Phone2
           ,@Phone3
           ,Getdate()
           ,Getdate()
           ,@RemainEnrollments
           ,@ContentLanguage
		   ,@LanguageSelected)
	END



