﻿

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_UserByUserIDAgentID1] 
(
	@AgentID int,
	@UserID varchar(20)
)
AS
	SET NOCOUNT ON;

	SELECT        UserID, LastName, FirstName, MidName, Department, Phone, Email, U.inputdate, admin, monitor, finance, dataEntry, password, status as statusID
	FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                     tblAuth A   with(nolock) ON U.authID = A.authID
	WHERE	UserID = @UserID AND AgentID = @AgentID

