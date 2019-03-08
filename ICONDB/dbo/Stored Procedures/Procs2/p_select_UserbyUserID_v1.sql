
create PROCEDURE [dbo].[p_select_UserbyUserID_v1]
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
		SELECT A.AuthID, UserID, @pwd as Password , LastName, FirstName,
			   ISNULL(MidName,"") as MidName,ID, AgentID,  ISNULL(Department,"") as Department, Phone, Email, U.inputdate,
			   ISNULL(Admin, 0) as Admin,
			   ISNULL(PowerUser,0) As PowerUser,
			   ISNULL([Finance-Auditor],0) as [Finance-Auditor],
			   ISNULL(Investigator,0) as Investigator,
			   ISNULL(DataEntry, 0) as DataEntry, 
			   ISNULL(UserDefine, 0) as UserDefine,
			   Status as StatusID, IPaddress,
			   Isnull(U.SecondFactor, 0) as SecondFactor,
			   (select RoleDescript from tblUserRole where RoleAuthID = A.authId) as groupRoleDescription
		FROM             tblUserprofiles U   with(nolock)  INNER JOIN
                         tblAuthUsers A    with(nolock) ON U.authID = A.AuthID
        WHERE	UserID = @UserID AND FacilityID = @FacilityID
       		
	END
ELSE
	BEGIN
		SELECT  A.AuthID, UserID, @pwd as password, LastName, FirstName, 
		      ISNULL(MidName,"") as MidName ,ID,  ISNULL(Department,"") as Department, Phone, Email,U.UserLevel, U.inputdate, 
			   ISNULL(Admin, 0) as Admin,
			   ISNULL(PowerUser,0) As PowerUser,
			   ISNULL([Finance-Auditor],0) as [Finance-Auditor],
			   ISNULL(Investigator,0) as Investigator,
			   ISNULL(DataEntry, 0) as DataEntry, 
			   ISNULL(UserDefine, 0) as UserDefine,
			    Status as StatusID, IPaddress,
			   A.AuthID,
			   Isnull(U.SecondFactor, 0) as SecondFactor,
			   (select RoleDescript from tblUserRole where RoleAuthID = A.authId) as groupRoleDescription
		FROM            tblUserprofiles U   with(nolock)  INNER JOIN
                         tblAuthUsers A   with(nolock) ON U.authID = A.AuthID
		WHERE	UserID = @UserID AND FacilityID = @FacilityID
		END