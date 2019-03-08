
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account3]
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
@relationshipID		tinyint,
@questionID		tinyint,
@securityA		varchar(100)

AS
SET NoCount ON ;

declare  @RecordID int, @NPA char(3), @NXX char(3),@STATE char(2), @stateID smallint, @countryID smallint, @EndUserID bigint;
SET @EndUserID =0;
if(LEN (@AccountNo) < 7) 
	Return 0; 

if (@FirstName='' or @FirstName='ICON Transfer' Or @LastName='For Prepaid')
	SET @relationshipID ='99';

If (@CountryCode  ='001' or @CountryCode='01' or @CountryCode is null)  SET @CountryCode ='1' ;

select @EndUserID  = EndUserID from tblEndUsers with(nolock)   where  UserName =@EndUserUserName ;
If @EndUserID > 0  
 begin
	If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo   ) > 0
		Return  -2;  ---UserName already  exist
	else
	begin
		SET @NPA = LEFT(@AccountNo,3);
		SET @NXX = SUBSTRING(@AccountNo,4,3);
		SELECT top 1 @STATE = [STATE]  from tblTPM with(nolock) where NPA = @NPA ;
		if(@STATE is null)
			SET @STATE ='CA';
		Select 	@stateID = stateID, @countryID= CountryID from tblStates with(nolock) where StateCode= @state;
		if(@stateID is null) 
		 begin
			set @stateID =0;
			set  @CountryID =203;
		 end
		SELECT @stateID = stateID,@CountryID = CountryID  from tblStates with(nolock) where Statecode= @STATE ;
		Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,RelationshipID, CountryCode, Country,StateID,CountryID)
		Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @EndUserID,@EndUserUserName, @InmateName,@RelationShipID, @CountryCode, @Country,@stateID ,@countryID );
	end 
		
 end

Else
 Begin
	if(LEFT(@AccountNo,3) <>'011')
	begin
		SET @NPA = LEFT(@AccountNo,3);
		SET @NXX = SUBSTRING(@AccountNo,4,3);
		SELECT top 1 @STATE = [STATE] from tblTPM with(nolock) where NPA = @NPA;
		if(@STATE is null)
			SET @STATE ='CA'
			
		
		SELECT @stateID = stateID,@CountryID = CountryID  from tblStates with(nolock) where Statecode= @STATE ;
		if(@stateID is null) 
		 begin
			set @stateID =0;
			set  @CountryID =203;
		 end
		EXEC [p_create_EndUserID] @RecordID OUTPUT ;
		Insert  Into tblEndUsers ( enduserID, UserName , Password , Email ,securityQ,securityA  )
			  Values (@RecordID,@EndUserUserName, @EnduserPassword,@Email,@questionID,@securityA ) ;

		Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,RelationshipID, CountryCode, Country,StateID,CountryID)
		Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@STATE,@MailingZip, 0,1,@FacilityID, @RecordID,@EndUserUserName, @InmateName,99, @CountryCode, @Country,@stateID ,@countryID ) ;
	end	
	--Return 0;
 End

If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo ) = 0
	begin 
		return 100 ;
	End

Return @@error
