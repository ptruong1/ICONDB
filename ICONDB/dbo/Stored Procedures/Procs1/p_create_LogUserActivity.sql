﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_create_LogUserActivity]
(
	@UserID varchar(20),
	@Activity varchar(50),
	@URL varchar(100),
	@ID smallint
	)
AS
SET NOCOUNT OFF;

IF (SELECT Count (*) FROM tblLogUserActivity where UserID =@UserID and URL = @URL) >0
	BEGIN
	   UPDATE [tblLogUserActivity] SET ActivityDate =GETDATE(),Activity=@Activity where UserID =@UserID and URL = @URL
	END
ELSE
	BEGIN
	  INSERT INTO [tblLogUserActivity] ([UserID], [Activity], [URL], [ActivityDate], [ID]) VALUES (@UserID, @Activity, @URL, GETDATE(),@ID)
	END

