


CREATE PROCEDURE [dbo].[P_INSERT_Oxford_Verification_Exception]
(
	@UserID varchar(16),
	@ProfileID nvarchar(100),
	@ActionType smallint,
	@RemainEnrollments int,
	@SharedPort int
)
AS
	SET NOCOUNT OFF;
if @actionType = 4
begin
DELETE FROM [dbo].[tblBioMetricProfileOxfordVerification]
      WHERE  UserID = @UserID
end
else
IF @userID in (SELECT userID FROM [dbo].[tblBioMetricProfileOxfordVerification] WHERE UserID = @UserID)
	BEGIN
		UPDATE [dbo].[tblBioMetricProfileOxfordVerification]
   SET 
      [ModifyDate] = Getdate()
      --,[ProfileID] = @ProfileID
	  ,RemainEnrollments = @RemainEnrollments
		WHERE UserID = @UserID
   END
ELSE
	BEGIN
		INSERT INTO [dbo].[tblBioMetricProfileOxfordVerification]
           ([UserID]
           ,[InputDate]
           ,[ModifyDate]
           ,[ProfileID]
		   ,RemainEnrollments
		   ,SharedPort)
     VALUES
           (@userID
           ,Getdate()
           ,Getdate()
		   ,@ProfileID
		   ,@RemainEnrollments
		   ,@SharedPort
		   )
	END




