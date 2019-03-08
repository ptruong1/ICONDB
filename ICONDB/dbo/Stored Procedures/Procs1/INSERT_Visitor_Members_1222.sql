

CREATE PROCEDURE [dbo].[INSERT_Visitor_Members_1222]
(
	@LastName  varchar(25) ,
	@FirstName  varchar(25) ,
	@Address  varchar(100) ,
	@City  varchar(25) ,
	@State  char(2) ,
	@Zipcode  varchar(9) ,
	@Phone  varchar(10) ,
	@DriverLicense varchar(25),
	@RelationshipID  tinyint,
	@Status int,
	@VisitorID int
)
AS
	SET NOCOUNT OFF;

	Declare  @return_value int, @nextID int, @ID int, @tblVisitorMembers nvarchar(32) ;
    EXEC   @return_value = p_create_nextID 'tblVisitorMembers', @nextID   OUTPUT
    set           @ID = @nextID ; 
	INSERT INTO [leg_Icon].[dbo].[tblVisitorMembers]
           (MemberID
           ,LastName
           ,FirstName
           ,DLID
           ,RelationshipID
            ,InputDate
			,VisitorID
			,Address 
			,City 
			,State 
			,Zipcode
			,Phone
			,Status)
     VALUES
           (@ID
           ,@LastName
           ,@FirstName
           ,@DriverLicense
           ,@RelationshipID
           ,GETDATE()
		   ,@VisitorID
		   ,@Address 
			,@City 
			,@State
			,@Zipcode
			,@Phone
			,@Status)
	
     Return 0;

	
	--INSERT INTO [leg_Icon].[dbo].[tblVisitorMembers]
 --          (LastName
 --          ,FirstName
 --          ,DLID
 --          ,RelationshipID
 --           ,InputDate
	--		,VisitorID
	--		,Address 
	--		,City 
	--		,State 
	--		,Zipcode
	--		,Phone
	--		,Status)
 --    VALUES
 --          (@LastName
 --          ,@FirstName
 --          ,@DriverLicense
 --          ,@RelationshipID
 --          ,GETDATE()
	--	   ,@VisitorID
	--	   ,@Address 
	--		,@City 
	--		,@State
	--		,@Zipcode
	--		,@Phone
	--		,@Status)
	
 --    Return 0;

