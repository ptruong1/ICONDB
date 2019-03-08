

CREATE PROCEDURE [dbo].[INSERT_Visitor_Infos_1029]
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
	@RelationShip varchar(20),
	@RecordOpt char(1) ,
	@Approved Char(1),
	@UserName varchar(25),
	@DriverLicense varchar(25),
	@EndUserID varchar(12),
	@VisitorID int OUTPUT
)
AS
	SET NOCOUNT OFF;
	Declare @password varchar(20)
	IF(SELECT COUNT(*) FROM tblVisitors where FacilityID = @FacilityID and EndUserID =@EndUserID ) > 0
		Return  -1;  --- Account number already exist
	Else
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
           ,[Relationship]
           ,RecordOpt
           ,Approved 
		   ,UserName
		   ,EndUserId
		   ,DriverLicense
		   ,InputDate)
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
           ,@Relationship
           ,@RecordOpt
           ,@Approved 
			,@UserName
			,@EndUserID
			,@DriverLicense
			,GETDATE())
			
		
			
     SET @VisitorID  = SCOPE_IDENTITY()
     Return 0;

