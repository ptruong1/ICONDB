
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account_ICON] 
@FacilityID	int,                ---Current use
@AccountNo  varchar(10),
@MaillingAddress	varchar(50),
@MailingCity	varchar(30),
@MailingZip		VARCHAR(5), 
@MailingState	varchar(2),
@CountryCode varchar(3),
@Country varchar(20),
@FirstName	VARCHAR(20)	, 
@LastName	VARCHAR(20),  
@Email	varchar(50),
@EndUserUserName  varchar(25),
@EnduserPassword	varchar(25),
@InmateName		varchar(50),
@relationshipID		tinyint,
@CountryID smallint,
@StateID smallint

AS
SET NoCount ON
declare  @RecordID int, @StateCode varchar(2) ;--, @CountryCode varchar(3),@Country varchar(20);

set @StateCode = 'CA';
if(LEN (@AccountNo) < 7) 
	Return 0; 

select @StateCode = stateCode from tblStates with(nolock) where StateID = @StateID and CountryID = @CountryID;

select @CountryCode = code from tblCountryCode with(nolock) where countryID= @CountryID;

If (@CountryCode  ='001' or @CountryCode='01' or @CountryCode is null )  SET @CountryCode ='1';

If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName) > 0  
	Return  -1;  ---UserName already  exist
If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo   ) > 0
	Return  -2;  --- Account number already exist
Else
 Begin
	EXEC [p_create_EndUserID] @RecordID OUTPUT
	Insert  Into tblEndUsers (EndUserID, UserName , Password , Email  )
		  Values (@RecordID,@EndUserUserName, @EnduserPassword,@Email);

	--SET @RecordID =SCOPE_IDENTITY()

	Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,RelationshipID, CountryCode, Country,CountryID,StateID)
	Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@StateCode,@MailingZip, 0,1,@FacilityID, @RecordID,@EndUserUserName, @InmateName,@RelationShipID, @CountryCode, @Country,@CountryID,@StateID);
	Return 0;
 End

If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo and FacilityID =@FacilityID  ) = 0
	begin 
		return 100;
	End

Return @@error;
