
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_UserByUserID3] 
(
	@FacilityID int,
	@UserID varchar(20)
)
AS
	SET NOCOUNT ON;
IF @FacilityID = 1
	BEGIN
		SELECT        UserID, Password, LastName, FirstName, MidName, AgentID, Department, Phone, Email, U.inputdate, admin, monitor, finance, dataEntry, controler, Status as StatusID, IPaddress
		FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                         tblAuth A    with(nolock) ON U.authID = A.authID
		WHERE	UserID = @UserID AND FacilityID = @FacilityID
	END
ELSE
	BEGIN
		SELECT        UserID, Password, LastName, FirstName, MidName, Department, Phone, Email,U.UserLevel, U.inputdate, admin, monitor, finance, dataEntry, Controler, Status as StatusID, IPaddress
		FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                         tblAuth A   with(nolock) ON U.authID = A.authID
		WHERE	UserID = @UserID AND FacilityID = @FacilityID
END
