-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_testing]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	   SET NOCOUNT ON;

   
		Declare @Password varchar(30) , @UserID varchar(30)

		DECLARE db_cursor CURSOR FOR  

		SELECT UserID from   tblUserprofiles where status =1
 

		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @UserID  ;  

		WHILE @@FETCH_STATUS = 0   
		BEGIN   
			   EXEC [p_retrieve_password_100814] 		@userID,		@Password  OutPut;
			   Insert INTO tblUserTemp values( @userID, @Password);
			   FETCH NEXT FROM db_cursor INTO @UserID    ;
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor
END

