

CREATE PROCEDURE [dbo].[INSERT_Visitor_Infos_1122]
(
	@VLastName  varchar(25) ,
	@VFirstName  varchar(25) ,
	@VMi  char(1) ,
	@Address  varchar(100) ,
	@City  varchar(25) ,
	@State  char(2) ,
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
	@StateID int,
	@VisitorID int OUTPUT
)
AS
	SET NOCOUNT OFF;
	Declare @password varchar(20)
	IF(SELECT COUNT(*) FROM tblVisitors where FacilityID = @FacilityID and EndUserID =@EndUserID ) > 0
		Return  -1;  --- Account number already exist
	Else
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
		   ,InputDate
		   ,StateID)
     VALUES
           (@ID
		   ,@VLastName
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
			,GETDATE()
			,@StateID)
		
			
     SET @VisitorID  = SCOPE_IDENTITY()
     Return 0;

