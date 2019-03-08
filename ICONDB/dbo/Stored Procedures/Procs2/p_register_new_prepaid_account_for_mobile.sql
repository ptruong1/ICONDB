
CREATE PROCEDURE [dbo].[p_register_new_prepaid_account_for_mobile]
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
@EnduserPassword  varchar(25),
@relationshipID		tinyint,
@StateID smallint,
@CountryID int,
@Result int output
AS
SET NoCount ON;
declare  @RecordID int;
SET @CountryCode ='1';
SET @RecordID =0;
if(LEN (@PhoneNo) < 7) 
begin
	set @Result = -3;
	Return 0; 
end
if ((@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid') AND (@relationshipID is null or @relationshipID =0))
	SET @relationshipID ='99';

SELECT @CountryCode = code from tblCountryCode with(nolock) where CountryID = @CountryID;
--Nhu add to test
if (@CountryCode in ('','0','1'))
 begin
	if(LEN (@PhoneNo) > 10)
		SET @PhoneNo = right(@PhoneNo,10);
 end
 
SELECT  @RecordID = EnduserID from  tblEndUsers with(nolock)   where  UserName =@PhoneNo and Password='Auto';
If ( @RecordID ) > 0  
  Begin
		If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo  ) =0
		 begin
				Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , [Address] ,  City,[State], ZipCode ,  Balance ,  [status],   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
				Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@PhoneNo, @RelationShipID, @CountryCode,  @StateID)
  
		 end
        else
		 begin
			Update tblEndUsers  SET [Password] = @EnduserPassword,
									[Email] = @Email
					where  UserName =@PhoneNo;
			Update tblPrepaid  SET FirstName = @FirstName,
									LastName = @LastName,
									[Address] =@MaillingAddress,
									city = @MailingCity,
									[state] = @MailingState,
									ZipCode = @MailingZip,
									[status]=1,
									facilityId =@facilityId,
									CountryID = @CountryID,
									StateID = @StateID,
									RelationshipID = @relationshipID,
									CountryCode = @CountryCode
				   Where PhoneNo = @PhoneNo;
		 end
  End
ELSE
 Begin
	If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo  ) > 0
	begin
		set @Result = -2;
		Return  -2;  --- Account number already exist
	end
	Else
	 Begin
		EXEC [p_create_EndUserID] @RecordID OUTPUT
		Insert  Into tblEndUsers ( enduserID, UserName , Password , Email ,securityQ )
			  Values (@RecordID,@PhoneNo, @EnduserPassword,@Email,0);
		Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
			  Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@PhoneNo, @RelationShipID, @CountryCode,  @StateID)
		set @Result = 0;
		
	 End
 End


If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo ) = 0
	begin 
		set @Result = 100;
		return 100;
	End

--If (select count(*) from tblFacilityOption where FacilityID = @FacilityID and VideoVisitOpt = 1) > 0
--begin
--   EXEC  [dbo].[p_Register_Visitor_Online] 
--	@LastName  ,
--	@FirstName  ,
--	'',
--	@MaillingAddress ,
--	@MailingCity  ,
--	@StateID ,
--	@MailingZip  ,
--	@countryID ,
--	@PhoneNo ,
--	'' ,
--	@Email  ,
--	@FacilityID ,
--	@RelationshipID  ,
--	@PhoneNo ,
--	'',
--	'',
--	'',
--	'',
--	'U'

--end



set @Result = @@error;
Return @@error;

