
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account7_Icon]
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
@questionID		tinyint,
@securityA		varchar(100)
AS
SET NoCount ON;
declare  @RecordID int;
SET @CountryCode ='1';

If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo  ) = 0
	
 Begin
	EXEC [p_create_EndUserID] @RecordID OUTPUT
	Insert  Into tblEndUsers 
	( enduserID, 
	UserName , 
	Password ,
	Email ,
	securityQ,
	securityA )
		  Values 
	(@RecordID,
	@PhoneNo,
	 @EnduserPassword,
	 @Email,
	 @questionID,
	 @securityA);

	Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName,RelationshipID,CountryCode,   StateID)
	Values(  @PhoneNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@PhoneNo, @RelationShipID, @CountryCode,  @StateID)
	Return 0;
 End

If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@PhoneNo  ) = 0
	begin 
		return 100;
	End

Return @@error;

