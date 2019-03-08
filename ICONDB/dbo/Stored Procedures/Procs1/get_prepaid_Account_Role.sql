


CREATE PROCEDURE [dbo].[get_prepaid_Account_Role]
(
	@EndUserUserName  varchar(25)
)
AS
SET NoCount ON
If (select count(*)  from  tblUserprofiles with(nolock)   where  UserID =@EndUserUserName) > 0
	Return 1;  ---  Legacy Employed login --- will go to different site that has Search function p_search_prepaid_account

If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName) = 0
	Return  -1;  -- Invalid login
Else
	return 0;



