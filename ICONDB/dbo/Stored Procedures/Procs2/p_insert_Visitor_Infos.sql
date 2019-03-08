

CREATE PROCEDURE [dbo].[p_insert_Visitor_Infos]
(
	@VLastName  varchar(25) ,  -- Current Using
	@VFirstName  varchar(25) ,
	@VMi  char(1) ,
	@Address  varchar(100) ,
	@City  varchar(25) ,
	@State  char(12) ,
	@Zipcode  varchar(9) ,
	@Phone1  varchar(12) ,
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
	@CountryID smallint ,
	@StateID   smallint,
	@DOB varchar(10),
	@Gender varchar(1),
	@VisitorID int OUTPUT
)
AS
	SET NOCOUNT OFF;
	Declare @password varchar(20), @ApprovedDate datetime, @ApprovedBy varchar(20) ;
	If(@Approved ='Y')
	 begin
		SET @ApprovedDate = getdate();
		SET @ApprovedBy = @UserName ;
	 end
	IF(SELECT COUNT(*) FROM tblVisitors where FacilityID = @FacilityID and EndUserID =@EndUserID ) > 0
		Return  -1;  --- Account number already exist
	Else
	Begin 
		EXEC [dbo].[p_register_new_prepaid_Account_ICON]
					@FacilityID,
					@EndUserID ,
					@Address	,
					@City	,
					@Zipcode		,
					@State	,
					1 ,
					'',
					@VFirstName	, 
					@VLastName	, 
					@Email	,
					@EndUserID  ,
					@EndUserID	,
					''		,
					@relationshipID		,
					@CountryID ,
					@StateID  ;

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
			   ,InputDate
			   ,StateID
			   ,CountryID
			   ,DOB
			   ,Gender
			   ,ApprovedDate
			   ,ApprovedBy
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
			   ,@Relationship
			   ,@RecordOpt
			   ,@Approved 
				,@UserName
				,@EndUserID
				,@DriverLicense
				,GETDATE()
				,@StateID
				,@CountryID
				,@DOB
				,@Gender
				,@ApprovedDate
				,@ApprovedBy
				) ;
				
			
				
		 SET @VisitorID  = SCOPE_IDENTITY() 
	  End	 
     Return 0;

