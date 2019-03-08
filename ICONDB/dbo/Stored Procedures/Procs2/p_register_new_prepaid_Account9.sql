CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account9]
@FacilityID	int,
@PhoneNo  varchar(12),
@MaillingAddress	varchar(50),
@MaillingAddressAptSuit varchar(100),
@MailingCity	varchar(30),
@MailingZip		VARCHAR(5), 
@MailingState	varchar(2),
@CountryCode varchar(3),
@FirstName	VARCHAR(20)	, 
@LastName	VARCHAR(20),  
@Email	varchar(50),
@EnduserPassword  varchar(25),
@relationshipID		tinyint,
@StateID smallint,
@CountryID int,
@note varchar(500)
AS
SET NoCount ON;
declare  @RecordID int;
SET @CountryCode ='1';
if(LEN (@PhoneNo) < 7) 
	Return 0; 

if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @relationshipID ='99';


SET @CountryCode ='1';
SET @RecordID =0;
if(LEN (@PhoneNo) < 7) 
	Return 0; 

if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @relationshipID ='99';

SELECT @CountryCode = code from tblCountryCode with(nolock) where CountryID = @CountryID;
SELECT  @RecordID = EnduserID from  tblEndUsers with(nolock)   where  UserName =@PhoneNo and ([Password]='Auto' or [Password] =@PhoneNo) ;
If ( @RecordID ) > 0  
  Begin
		If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo  ) =0
		 begin
				Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , [Address], Address1 ,  City,[State], ZipCode ,  Balance ,  [status],   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID, note)
				Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress, @MaillingAddressAptSuit, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@PhoneNo, @RelationShipID, @CountryCode,  @StateID, @note)
  
		 end
        else
		 begin
			Update tblEndUsers  SET [Password] = @EnduserPassword,
									[Email] = @Email
					where  UserName =@PhoneNo;
			Update tblPrepaid  SET FirstName = @FirstName,
									LastName = @LastName,
									[Address] =@MaillingAddress,
									Address1= @MaillingAddressAptSuit,
									city = @MailingCity,
									[state] = @MailingState,
									ZipCode = @MailingZip,
									[status]=1,
									facilityId =@facilityId,
									CountryID = @CountryID,
									StateID = @StateID,
									RelationshipID = @relationshipID,
									CountryCode = @CountryCode,
									note = @note
				   Where PhoneNo = @PhoneNo;
		 end
  End
ELSE
 Begin
	If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo   ) > 0
		Return  -2;  --- Account number already exist
	Else
	 Begin
		EXEC [p_create_EndUserID] @RecordID OUTPUT
		Insert  Into tblEndUsers ( enduserID, UserName , Password , Email ,securityQ )
			  Values (@RecordID,@PhoneNo, @EnduserPassword,@Email,0);
		Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address, Address1 ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID, note)
			  Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress,@MaillingAddressAptSuit, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@PhoneNo, @RelationShipID, @CountryCode,  @StateID,@note)
		Return 0;
	 End
 End
If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo and FacilityID =@FacilityID  ) = 0
	begin 
		return 100;
	End

Return @@error;

