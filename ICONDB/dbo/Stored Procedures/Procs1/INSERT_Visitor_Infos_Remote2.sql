
CREATE PROCEDURE [dbo].[INSERT_Visitor_Infos_Remote2]
(
	@VLastName  varchar(25) ,
	@VFirstName  varchar(25) ,
	@VMi  char(1) ,
	@Address  varchar(100) ,
	@City  varchar(25) ,
	@StateID  smallint,
	@Zipcode  varchar(9) ,
	@Phone1  varchar(10) ,
	@Phone2  varchar(10) ,
	@Email  varchar(35) ,
	--@InmateID  varchar(12) ,
	@FacilityID  int ,
	--@RelationshipID  tinyint,
	@RecordOpt char(1) ,
	@VisitType tinyint,
	@UserName varchar(25),
	@DriverLicense varchar(25),
	@EndUserId varchar(10), 
	@countryID smallint
	--@VImage char(1)
	--@Relationship varchar(20)

)
AS

SET NOCOUNT OFF;
Declare @VisitorID int ,	@ApprovedStatus char(1), @RelationshipID smallint;
SET @RelationshipID =99;
if (select COUNT(*) from [tblVisitors] where FacilityID =@FacilityID and EndUserID =@EndUserId) > 0
	return -1;
		
If(@VisitType=2)
	SET @ApprovedStatus ='Y';
else
 begin
	SET @ApprovedStatus ='P';
	if(SELECT COUNT(*) FROM [tblVisitFacilityConfig] where facilityID = @facilityID and VisitRegReq=1) >0
		SET @ApprovedStatus ='P';
	else
	 begin
		
		SET @ApprovedStatus ='Y';
		
	 end
 end

select @RelationshipID  =RelationshipID from tblPrepaid with(nolock) where phoneno = @Phone1 ;
if( @RelationshipID in (7,8))
 begin
	SET @ApprovedStatus ='P';
	SET @RecordOpt ='N';
 end

INSERT INTO [leg_Icon].[dbo].[tblVisitors]
           ([VLastName]
           ,[VFirstName]
           ,[VMi]
           ,[Address]
           ,[City]
           ,[StateID]
           ,[Zipcode]
           ,[Phone1]
           ,[Phone2]
           ,[Email]
           ,[InmateID]
           ,[FacilityID]
           ,[RelationshipID]
           ,RecordOpt
           ,Approved 
		   ,UserName
		   ,DriverLicense
		   ,EndUserID
		    ,InputDate
		   ,countryID
		   ,VImage
		   )
     VALUES
           (@VLastName
           ,@VFirstName
           ,@VMi
           ,@Address
           ,@City
           ,@StateID
           ,@Zipcode
           ,@Phone1
           ,@Phone2
           ,@Email
           ,'0'
           ,@FacilityID
            ,@RelationshipID
           ,@RecordOpt
           ,@ApprovedStatus
			,@UserName
			,'Y'
			,@EndUserId
			,GETDATE()
			,@countryID
			,'Y'
			
			)	;
					
SET @VisitorID  = SCOPE_IDENTITY();

if(@@ERROR>0)
	return -2;
			
if(@ApprovedStatus ='Y')
	return 1;
else
	return 0;
     
