

CREATE PROCEDURE [dbo].[INSERT_Visitor_Infos_1022]
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
	@Approved Char(1),
	@UserName varchar(25),
	@DriverLicense varchar(25),
	@EndUserID varchar(12),
	@VisitorID int OUTPUT
)
AS
	SET NOCOUNT OFF;
	--SET @Approved ='Y'
	EXEC [p_create_VisitorID] @VisitorID  output
	INSERT INTO [tblVisitors]
           (VisitorID 
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
           ,RecordOpt
           ,Approved 
		   ,UserName
		   ,EndUserId
		   ,DriverLicense
		   ,InputDate)
     VALUES
           (@VisitorID 
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
           ,@RecordOpt
           ,@Approved 
			,@UserName
			,@EndUserID
			,@DriverLicense
			,GETDATE())
			
    -- SET @VisitorID  = SCOPE_IDENTITY()

