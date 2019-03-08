

CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account6]
@FacilityID	int,
@PhoneNo  varchar(12),
@MaillingAddress	varchar(50),
@MailingCity	varchar(30),
@MailingZip		VARCHAR(5), 
@MailingState	varchar(2),
@CountryCode varchar(3),
@FirstName	VARCHAR(20)	, 
@LastName	VARCHAR(20),  
@Email	varchar(50),
@EndUserUserName  varchar(25),
@EnduserPassword	varchar(25),
@relationshipID		tinyint,
@StateID smallint,
@CountryID int
AS
SET NoCount ON;
declare  @RecordID int;
if(LEN (@PhoneNo) < 7) 
	Return 0; 

SET @CountryCode ='1';
SELECT @CountryCode = code from tblCountryCode with(nolock) where CountryID = @CountryID;

Declare @EndUserID bigint,  @pw varchar(20) ;

if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @relationshipID ='99';

select @EndUserID  = EndUserID, @pw = [Password] from tblEndUsers with(nolock)   where  UserName =@EndUserUserName ;
If (@EndUserID >0 )
 begin
    if( @pw= 'Auto' )
	 begin
		Update tblEndUsers set [Password] = @EnduserPassword, Email = @Email  where  UserName =@EndUserUserName ;
		If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo and FacilityID =@FacilityID  ) > 0
			Update tblPrepaid set Address= @MaillingAddress, City= @MailingCity, ZipCode= @MailingZip, [state]= @MailingState, RelationshipID= @relationshipID,
					 FacilityID =@FacilityID, FirstName=@FirstName, LastName = @LastName where PhoneNo = @PhoneNo;
		Else
		 Begin
			Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
			Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@EndUserUserName, @RelationShipID, @CountryCode,  @StateID)
			Return 0;
		 End
	 end
	else
	 begin
		Return  -1;  ---UserName already  exist
	 end
 end
else
 begin
	EXEC [p_create_EndUserID] @RecordID OUTPUT
		Insert  Into tblEndUsers ( enduserID, UserName , Password , Email ,securityQ )
			  Values (@RecordID,@PhoneNo, @EnduserPassword,@Email,0);

		Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
		Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@EndUserUserName, @RelationShipID, @CountryCode,  @StateID)
		Return 0;
 end



If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo and FacilityID =@FacilityID  ) = 0
	begin 
		return 100;
	End

Return @@error

