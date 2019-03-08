
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account5]
@FacilityID	int,
@AccountNo  varchar(12),
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
@questionID		tinyint,
@securityA		varchar(100),
@status		tinyint,
@StateID int
AS
SET NoCount ON;
declare  @RecordID int;

SET @CountryCode ='1';

if(LEN (@AccountNo) < 7) 
	Return 0; 

if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @relationshipID ='99';

If (@CountryCode  ='001' or @CountryCode='01')  SET @CountryCode ='1'

SET @RecordID =0;
if(LEN (@AccountNo) < 7) 
	Return 0; 


--SELECT @CountryCode = code from tblCountryCode with(nolock) where CountryID = @CountryID;

SELECT  @RecordID = EnduserID from  tblEndUsers with(nolock)   where  UserName =@AccountNo and ([Password]='Auto' or [Password] =@AccountNo) ;

If ( @RecordID  > 0  )
  Begin
		If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo  ) =0
		 begin
				Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , [Address] ,  City,[State], ZipCode ,  Balance ,  [status],   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
				Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@AccountNo, @RelationShipID, @CountryCode,  @StateID)
  
		 end
        else
		 begin
			Update tblEndUsers  SET [Password] = @EnduserPassword,
									[Email] = @Email
					where  UserName =@AccountNo;
			Update tblPrepaid  SET FirstName = @FirstName,
									LastName = @LastName,
									[Address] =@MaillingAddress,
									city = @MailingCity,
									[state] = @MailingState,
									ZipCode = @MailingZip,
									[status]=1,
									facilityId =@facilityId,
									CountryID =203,
									StateID = @StateID,
									RelationshipID = @relationshipID,
									CountryCode = @CountryCode
				   Where PhoneNo = @AccountNo;
		 end
  End
ELSE
 Begin
	If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo   ) > 0
		Return  -2;  --- Account number already exist
	Else
	 Begin
		EXEC [p_create_EndUserID] @RecordID OUTPUT
		Insert  Into tblEndUsers ( enduserID, UserName , Password , Email ,securityQ )
			  Values (@RecordID,@AccountNo, @EnduserPassword,@Email,0);
		Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
			  Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@AccountNo, @RelationShipID, @CountryCode,  @StateID)
		Return 0;
	 End
 End
If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo   ) = 0
	begin 
		return 100;
	End

Return @@error;


