
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account_service]
@FacilityID	int,
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
@relationshipID		tinyint

AS
SET NoCount ON
If (@CountryCode  ='001' or @CountryCode='01')  SET @CountryCode ='1'

	Insert tblPrepaidService ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,RelationshipID, CountryCode, Country, Email)
	Values( @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID,0,@EndUserUserName, @InmateName,@RelationShipID, @CountryCode, @Country,@Email)
	Return 0;

