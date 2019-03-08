

CREATE PROCEDURE [dbo].[p_login_prepaid_Account]
@EndUserUserName  varchar(25),
@EnduserPassword	varchar(25)

AS
SET NoCount ON
declare  @RecordID int, @fistName char(1) ,  @defaultPassword  char(8)
/*
If (select count(*)  from  tblUserprofiles with(nolock)   where  UserID =@EndUserUserName and  Password =@EnduserPassword AND FacilityID <=2 ) > 0
	
	Return 1  ---  Legacy Employed login --- will go to different site that has Search function p_search_prepaid_account
*/

If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName and  Password =@EnduserPassword ) = 0
 Begin
	If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName  ) = 1
	  Begin
		select  @fistName = left(firstName ,1) from tblprepaid with(nolock) where PhoneNo = @EndUserUserName
		SET @defaultPassword =  @fistName + right(@EndUserUserName ,7)
		If( @EnduserPassword =  @defaultPassword    )
		 Begin
			select  PhoneNo ,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status  from   tblPrepaid with(nolock) ,   tblEndUsers  with(nolock)
				where  tblPrepaid.EnduserID = tblEndUsers.EnduserID  and  tblEndUsers.UserName =@EndUserUserName and tblPrepaid.status = 1 
				return 0;
		 End 
		Else
			Return  -1
	  End
	Else 
		Return  -1  -- Invalid login
 End
Else
 Begin
	
	select  PhoneNo ,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status  from   tblPrepaid with(nolock) ,   tblEndUsers  with(nolock)
	where  tblPrepaid.EnduserID = tblEndUsers.EnduserID  and  tblEndUsers.UserName =@EndUserUserName and  tblEndUsers.password =@EnduserPassword and tblPrepaid.status = 1 
	return 0;
 End

