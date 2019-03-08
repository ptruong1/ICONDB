
CREATE PROCEDURE [dbo].[p_visitation_user_login]
@ServerIP	varchar(20),
@userName	varchar(25),
@password	varchar(25)
AS
SET NOCOUNT ON
Declare  @FacilityID	int
SET  @FacilityID =0
Select   @FacilityID = FacilityID from tblVisitPhoneServer with(nolock)  Where ServerIP = @ServerIP;
If (Select  count(*) from tblUserprofiles with(nolock) where userID= @userName  and password = @password) > 0
	Return 1;
else
	Return -1;

