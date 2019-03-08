
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_UserByUserID5] 
(
	@FacilityID int,
	@UserID varchar(20)
)
AS
	SET NOCOUNT ON;
	Declare @pwd varchar(20)

	-- Don't display password to any user
	SET  @pwd  ="*****";
	--EXEC [dbo].[p_retrieve_password_100814] @userID, @pwd  OUTPUT;
	--print @pwd
	
	
IF @FacilityID = 1
	BEGIN
		SELECT        UserID, @pwd as password , LastName, FirstName, MidName, ID, AgentID, Department, Phone, Email, U.inputdate, admin, monitor, finance, dataEntry, controler, Status as StatusID, IPaddress
		FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                         tblAuth A    with(nolock) ON U.authID = A.authID
		WHERE	UserID = @UserID AND FacilityID = @FacilityID
	END
ELSE
	BEGIN
		SELECT        UserID, @pwd as password, LastName, FirstName, MidName, ID, Department, Phone, Email,U.UserLevel, U.inputdate, admin, monitor, finance, dataEntry, Controler, Status as StatusID, IPaddress
		FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                         tblAuth A   with(nolock) ON U.authID = A.authID
		WHERE	UserID = @UserID AND FacilityID = @FacilityID
END
