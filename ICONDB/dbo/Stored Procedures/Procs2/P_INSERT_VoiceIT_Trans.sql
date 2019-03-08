


CREATE PROCEDURE [dbo].[P_INSERT_VoiceIT_Trans]
		   (@UserEmail varchar(50)
           ,@UserID varchar(16)
           ,@FirstName varchar(16)
           ,@LastName varchar(16)
           ,@TransType int
           ,@FilePath varchar(100)
           ,@ReturnCode varchar(3)
           ,@Response varchar(100)
           ,@RemainEnrollments int
           ,@ContentLanguage varchar(12)
		   )
AS
	SET NOCOUNT OFF;

	BEGIN   
	INSERT INTO [dbo].[tblBioMetricVoiceIT_Trans]
           ([UserEmail]
           ,[UserID]
           ,[FirstName]
           ,[LastName]
           ,[TransType]
           ,[FilePath]
           ,[ReturnCode]
           ,[Response]
           ,[InputDate]
           ,[RemainEnrollments]
           ,[ContentLanguage])
     VALUES
           (@UserEmail
           ,@UserID
           ,@FirstName
           ,@LastName
           ,@TransType
           ,@FilePath
           ,@ReturnCode
           ,@Response
           ,getDate()
           ,@RemainEnrollments
           ,@ContentLanguage)

	END


