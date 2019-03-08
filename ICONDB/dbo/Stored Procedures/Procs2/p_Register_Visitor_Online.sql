
CREATE PROCEDURE [dbo].[p_Register_Visitor_Online]
(
	@VLastName  varchar(25) ,
	@VFirstName  varchar(25) ,
	@VMi  char(1) ,
	@Address  varchar(100) ,
	@City  varchar(25) ,
	@StateID  smallint,
	@Zipcode  varchar(9) ,
	@countryID smallint,
	@Phone1  varchar(12) ,
	@Phone2  varchar(12) ,
	@Email  varchar(35) ,
	@FacilityID  int ,
	@RelationshipID  tinyint,
	@UserName varchar(25),
	@DriverLicense varchar(25),
	@VImage varchar(150),
	@VDLImage varchar(150),
	@DOB varchar(12),
	@Gender char(1)

)
AS

SET NOCOUNT OFF;
Declare @VisitorID int ,	@ApprovedStatus char(1) ,@recordOpt varchar(1), @VisitRegReq tinyint, @ApprovedBy varchar(20), @ApprovedDate datetime ;
SET @recordOpt  ='Y';
SET @ApprovedStatus ='P';
if (select COUNT(*) from [tblVisitors] where FacilityID =@FacilityID and Phone1 =@Phone1) > 0
	return -1;

SELECT @recordOpt = isnull(RecordOpt,'Y'),@VisitRegReq= VisitRegReq   from  [tblVisitFacilityConfig] with(nolock) where facilityID = @facilityID ;
		
if(@VisitRegReq >0)
	SET @ApprovedStatus ='P';
else
 begin		
	SET @ApprovedStatus ='Y';
	SET @ApprovedBy  ='Auto';
	SET @ApprovedDate = getdate();
 end
		
Declare  @return_value int, @nextID int, @ID int, @tblVisitors nvarchar(32) ;
EXEC   @return_value = p_create_nextID 'tblVisitors', @nextID   OUTPUT
        set           @ID = @nextID ; 
INSERT INTO [leg_Icon].[dbo].[tblVisitors]
           ([VisitorID]
		   ,[VLastName]
           ,[VFirstName]
           ,[VMi]
           ,[Address]
           ,[City]
           ,[StateID]
           ,[Zipcode]
           ,[Phone1]
           ,[Phone2]
           ,[Email]
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
		   ,VDLImage
		   ,DOB
		   ,Gender
		   , InmateID
		   ,ApprovedBy
		   ,ApprovedDate
		   )
     VALUES
           (@ID
		   ,@VLastName
           ,@VFirstName
           ,@VMi
           ,@Address
           ,@City
           ,@StateID
           ,@Zipcode
           ,@Phone1
           ,@Phone2
           ,@Email
           ,@FacilityID
            ,@RelationshipID
           ,@recordOpt
           ,@ApprovedStatus
			,@UserName
			,@DriverLicense
			,@Phone1
			,GETDATE()
			,@countryID
			,@VImage
			,@VDLImage
			,@DOB
			,@Gender
			,'0'
			,@ApprovedBy
			,@ApprovedDate
			)	;
					
SET @VisitorID  = @ID;

if(@@ERROR>0)
	return -2;
			
if(@ApprovedStatus ='Y')
	return 1;
else
	return 0;
     
