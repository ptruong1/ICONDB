﻿
CREATE PROCEDURE [dbo].[p_Delete_CustomReport]
(
	@UserID varchar(20),
	@Title varchar(100)
)
AS
	SET NOCOUNT OFF;
DELETE FROM [tblCustomReport] WHERE (([UserID] = @UserID) and Title = @Title)

