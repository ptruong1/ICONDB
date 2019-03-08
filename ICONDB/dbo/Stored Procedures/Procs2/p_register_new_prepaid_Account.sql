
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account]
@FacilityID	int,
@AccountNo  varchar(10),
@MaillingAddress	varchar(50),
@MailingCity	varchar(30),
@MailingZip		VARCHAR(5), 
@MailingState	varchar(2),
@FirstName	VARCHAR(20)	, 
@LastName	VARCHAR(20),  
@Email	varchar(50),
@EndUserUserName  varchar(25),
@EnduserPassword	varchar(25)

AS
SET NoCount ON
declare  @RecordID int

If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName) > 0  
	Return  -1;  ---UserName already  exist
If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo  ) > 0
	Return  -2;  --- Account number already exist
Else
 Begin
	Insert  Into tblEndUsers ( UserName , Password , Email  )
		  Values (@EndUserUserName, @EnduserPassword,@Email)

	SET @RecordID =SCOPE_IDENTITY()

	Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName)
	Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@EndUserUserName)
	Return 0;
 End

