

CREATE PROCEDURE [dbo].[INSERT_Visitor_Infos_Remote]
(
	@VLastName  varchar(25) ,
	@VFirstName  varchar(25) ,
	@VMi  char(1) ,
	@Address  varchar(100) ,
	@City  varchar(25) ,
	@State  char(12) ,
	@Zipcode  varchar(9) ,
	@Phone1  varchar(10) ,
	@Phone2  varchar(10) ,
	@Email  varchar(35) ,
	@InmateID  varchar(12) ,
	@FacilityID  int ,
	@RelationshipID  tinyint,
	@RecordOpt char(1) ,
	@VisitType tinyint,
	@UserName varchar(25),
	@DriverLicense varchar(25),
	@EndUserId varchar(10),
	@VisitorID int OUTPUT,
	@ApprovedStatus char(1) OUTPUT
)
AS
	SET NOCOUNT OFF;
	
	If(@VisitType=2)
		SET @ApprovedStatus ='Y';
	else
	 begin
		SET @ApprovedStatus ='P'
		if(SELECT COUNT(*) FROM [tblFacilityOption] where facilityID = @facilityID and VisitRegReq=1) >0
			SET @ApprovedStatus ='P';
		else
		    SET @ApprovedStatus ='Y';
     end
	If(@RelationshipID in (7,8))
		SET @ApprovedStatus ='P';
	INSERT INTO [leg_Icon].[dbo].[tblVisitors]
           ([VLastName]
           ,[VFirstName]
           ,[VMi]
           ,[Address]
           ,[City]
           ,[State]
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
		   )
     VALUES
           (@VLastName
           ,@VFirstName
           ,@VMi
           ,@Address
           ,@City
           ,@State
           ,@Zipcode
           ,@Phone1
           ,@Phone2
           ,@Email
           ,@InmateID
           ,@FacilityID
           ,@RelationshipID
           ,@RecordOpt
           ,@ApprovedStatus
			,@UserName
			,@DriverLicense
			,@EndUserId
			,GETDATE())			;
			SET @VisitorID  = SCOPE_IDENTITY() ;
if(@ApprovedStatus ='Y')
	return 1;
else
	return 0;
     

