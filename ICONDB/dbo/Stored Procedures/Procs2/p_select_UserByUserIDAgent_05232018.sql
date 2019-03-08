

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[p_select_UserByUserIDAgent_05232018] 
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

SELECT  A.AuthID, UserID, @pwd as password, LastName, FirstName, MidName,ID, Department, Phone, Email,U.UserLevel, U.inputdate, 
			   ISNULL(Admin, 0) as Admin,
			   ISNULL(PowerUser,0) As PowerUser,
			   ISNULL([Finance-Auditor],0) as [Finance-Auditor],
			   ISNULL(Investigator,0) as Investigator,
			   ISNULL(DataEntry, 0) as DataEntry, 
			   ISNULL(UserDefine, 0) as UserDefine,
			    Status as StatusID, IPaddress,
			   A.AuthID,
			    isnull(SecondFactor, 0) as SecondFactor

	--SELECT        UserID,  LastName, FirstName, MidName, Department, Phone, Email, U.inputdate, admin, monitor, finance, dataEntry, Controler, @pwd as Password, status as statusID, IPAddress
	FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                     tblAuthUsers A   with(nolock) ON U.authID = A.authID
	WHERE	UserID = @UserID AND AgentID = @AgentID

