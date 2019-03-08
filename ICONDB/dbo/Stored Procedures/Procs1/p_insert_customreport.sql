CREATE PROCEDURE [dbo].[p_insert_customreport]
(
	@UserID varchar(20),
	@Title varchar(100),
	@URL varchar(1000),
	@ID as smallint
	)
AS

SET NOCOUNT OFF;
If(@ID =1)
Begin
 INSERT INTO [tblCustomReport] ([UserID], [Title], [URL], [InputDate], [ModifyDate]) VALUES (@UserID, @Title, @URL, GETDATE(), GETDATE())
End
Else
	BEGIN
	   UPDATE [tblCustomReport] SET InputDate =GETDATE(), ModifyDate =GETDATE(), URL = @URL where UserID = @UserID and Title= @Title
	END
--IF (SELECT Count (*) FROM tblCustomReport where UserID =@UserID and URL = @URL and Title =@Title) >0
--	BEGIN
--	   UPDATE [tblCustomReport] SET InputDate =GETDATE(), ModifyDate =GETDATE()
--	END
--ELSE
--	BEGIN
	 
--	END

