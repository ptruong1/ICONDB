
CREATE PROCEDURE [dbo].[p_Update_prepaid_Account_ICON_Test]
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
@StateID int,
@CountryID int
AS
SET NoCount ON;
declare  @RecordID int;
--if(LEN (@AccountNo) < 7) 
--	Return 0; 

--if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
--	SET @relationshipID ='99';

--If (@CountryCode  ='001' or @CountryCode='01')  SET @CountryCode ='1'

--If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName) > 0
--	--UPDATE     tblEndUsers
--	--	set 
--	--	 UserName = @EndUserUserName
--	--	, Email = @Email
		
--	--WHERE  tblEndUsers.enduserID = @EndUserUserName ;
--	Return  -1;  ---UserName already  exist

 Begin
	EXEC [p_create_EndUserID] @RecordID OUTPUT
	Insert  Into tblEndUsers ( enduserID, UserName , Password , Email ,securityQ,securityA  )
		  Values (@RecordID,@EndUserUserName, @EnduserPassword,@Email,@questionID,@securityA );

	

	Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,RelationshipID, CountryCode, Country, StateID)
	Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,@status,@FacilityID, @RecordID,@EndUserUserName, @InmateName,@RelationShipID, @CountryCode, @Country, @StateID);
	Return 0;
 End

If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo and FacilityID =@FacilityID  ) = 0
	begin 
		return 100;
	End

Return @@error
