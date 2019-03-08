

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_UserByUserIDAgentID3] 
(
	@AgentID int,
	@UserID varchar(20)
)
AS
	SET NOCOUNT ON;
	Declare @pwd varchar(20)
	-- Don't display password to any user
	SET  @pwd  ="*****";
	--EXEC [dbo].[p_retrieve_password_100814] @userID, @pwd  OUTPUT;

	SELECT        UserID,  LastName, FirstName, MidName, Department, Phone, Email, U.inputdate, admin, monitor, finance, dataEntry, Controler, @pwd as Password, status as statusID, IPAddress
	FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                     tblAuth A   with(nolock) ON U.authID = A.authID
	WHERE	UserID = @UserID AND AgentID = @AgentID
