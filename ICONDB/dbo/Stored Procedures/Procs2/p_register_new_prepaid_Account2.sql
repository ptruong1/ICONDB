
CREATE PROCEDURE [dbo].[p_register_new_prepaid_Account2] 
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
SET NoCount ON;
declare  @RecordID int, @VisitApprove  varchar(1), @RecordOpt varchar(1), @visitRegReq tinyint, @visitOpt tinyint, @VisitIDReq tinyint,@VisitPicReq tinyint;

SET @VisitPicReq=0;
SET @VisitIDReq =0; 
If (@CountryCode  ='001' or @CountryCode='01')  SET @CountryCode ='1';

If (select count(*)  from  tblEndUsers with(nolock)   where  UserName =@EndUserUserName) > 0  
	Return  -1;  ---UserName already  exist
If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo  ) > 0
	Return  -2;  --- Account number already exist
Else
 Begin
	EXEC [p_create_EndUserID] @RecordID OUTPUT;
	Insert  Into tblEndUsers (EndUserID, UserName , Password , Email  )
		  Values (@RecordID,@EndUserUserName, @EnduserPassword,@Email);

	--SET @RecordID =SCOPE_IDENTITY()

	Insert tblPrepaid ( PhoneNo,  FirstName , LastName  , Address ,  City,State, ZipCode ,  Balance ,  status,   FacilityID, EndUserID,UserName, InmateName,RelationshipID, CountryCode, Country,CountryID,StateID)
	Values(  @AccountNo, @FirstName, @LastName, @MaillingAddress, @MailingCity,@MailingState,@MailingZip, 0,1,@FacilityID, @RecordID,@EndUserUserName, @InmateName,@RelationShipID, @CountryCode, @Country,@CountryID,@StateID);
	
 End

If  (select count (*) from  tblPrepaid  with(nolock)  where PhoneNo =@AccountNo and FacilityID =@FacilityID  ) = 0
	begin 
		return 100;
	End


if(select count(*) from tblFacilityOption where FacilityID = @FacilityID and VideovisitOpt =1) > 0
 begin
	SET  @VisitApprove ='Y';
	SET @RecordOpt ='Y';
	SET @visitOpt = 0;
	SET @visitRegReq =0;
	select @visitOpt  = VisitOpt, @visitRegReq = VisitRegReq, @VisitIDReq = VisitIDReq, @VisitPicReq =VisitPicReq   from tblVisitFacilityConfig with(nolock) where FacilityID = @FacilityID;
   if( @visitRegReq =1)
    begin
		SET @VisitApprove ='P';
     end
	if(@relationshipID in (7,8))
	 begin
		SET @VisitApprove ='P';
		SET @RecordOpt ='N';
	 end
	 if(@VisitPicReq=0)	
	  begin
		 if( select count(*) from tblvisitors with(nolock) where FacilityID = @FacilityID and Phone1 = @AccountNo ) =0
		  begin
			 INSERT INTO [leg_Icon].[dbo].[tblVisitors]  ([VLastName]  ,[VFirstName]  ,[VMi] ,[Address] ,[City]  ,[State] ,[Zipcode] ,[Phone1] ,[Phone2] ,[Email] ,[InmateID]
					   ,[FacilityID] ,[RelationshipID] ,[Relationship]  ,RecordOpt  ,Approved   ,UserName ,EndUserId ,DriverLicense  ,InputDate  ,StateID  ,CountryID)					   
					   	 VALUES    (@LastName  ,@FirstName   ,''   ,@MaillingAddress   ,@MailingCity  ,@MailingState ,@MailingZip   ,@AccountNo  ,'' ,@Email ,'0'
					   ,@FacilityID ,@RelationshipID ,'' ,@RecordOpt   ,@VisitApprove,@AccountNo,@AccountNo,''	,GETDATE()	,@StateID,@CountryID) ;
			end
	end
 end	

Return @@error;
