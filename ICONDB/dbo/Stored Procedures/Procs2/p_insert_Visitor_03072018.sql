

CREATE PROCEDURE [dbo].[p_insert_Visitor_03072018]
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
	@UserIP varchar(25),
	@ApprovedApm bit,
	@VisitorID int OUTPUT
)
AS
	SET NOCOUNT OFF;
	Declare @password varchar(20), @ApprovedBy varchar(25), @ApprovedDate datetime;
	Declare  @UserAction varchar(100),@ActTime datetime;
	Declare  @return_value int, @nextID int, @ID int, @tblVisitors nvarchar(32) ;
	If @Approved = 'P'
		 set @ApprovedBy = 'Pending'
	else 
	 begin
		set @ApprovedBy =@UserName;
		SET @ApprovedDate = getdate();
	 end
	IF(SELECT COUNT(*) FROM tblVisitors where FacilityID = @FacilityID and EndUserID =@EndUserID ) > 0
		begin
			SET @VisitorID  = (SELECT visitorId FROM tblVisitors where FacilityID = @FacilityID and EndUserID =@EndUserID )
			Return  -1  --- Account number already exist
		end
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
			   ,StateID
			   ,CountryID
			   ,DOB
			   ,Gender
			   ,ApprovedBy
			   ,ApprovedApm
			   ,ApprovedDate
			   )
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
				,@StateID
				,@CountryID
				,@DOB
				,@Gender
				,@ApprovedBy
				,@ApprovedApm
				,@ApprovedDate
				) 
				;
				
		 SET @VisitorID  = @ID 
		 SET  @UserAction =  'Register Visit for VisitorID' +CAST (@VisitorID as varchar(15));
	EXEC [p_get_facility_time] @facilityID ,@ActTime OUTPUT ;

	EXEC  INSERT_ActivityLogs3	@FacilityID ,22 ,@ActTime, 0,@UserName ,@UserIP, @InmateID,@UserAction ;
	  End	 
	  
     Return 0;

