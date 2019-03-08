

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_Users1] 
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
IF @FacilityID = 1
	BEGIN
		SELECT        UserID, LastName, FirstName, AgentID, admin, monitor, finance, dataEntry, Controler
		FROM            tblUserprofiles U  with(nolock)  INNER JOIN
                         tblAuth A  with(nolock)  ON U.authID = A.authID
		WHERE			FacilityID = @FacilityID;
	END
ELSE
	BEGIN
		SELECT        UserID, LastName, FirstName, admin, monitor, finance, dataEntry, Controler
		FROM            tblUserprofiles U  with(nolock)  INNER JOIN
								 tblAuth A  with(nolock) ON U.authID = A.authID
		WHERE			FacilityID = @FacilityID;
END
