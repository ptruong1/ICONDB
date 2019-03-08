

CREATE PROCEDURE [dbo].[Update_VisitorMembers]
(
	@LastName  varchar(25) 
	,@FirstName  varchar(25) 
	,@Address  varchar(100) 
	,@City  varchar(25) 
	,@State  char(2) 
	,@Zipcode  varchar(9) 
	,@Phone  varchar(10) 
	,@DriverLicense varchar(25)
	,@RelationshipID  tinyint
	,@Status int
	,@VisitorID int
	,@MemberID int
)
AS
	SET NOCOUNT OFF;

if (select count(*) from dbo.tblVisitorMembers where (MemberID = @MemberID) and (Status <> 3)) > 0
  Begin
  Update [leg_Icon].[dbo].[tblVisitorMembers]
	Set
            LastName =@LastName
           ,FirstName =@FirstName
           ,DLID =@DriverLicense
           ,RelationshipID = @RelationshipID
            ,ModifyDate =GETDATE()
			,Address =@Address 
			,City =@City 
			,State =@State
			,Zipcode=@Zipcode
			,Phone=@Phone
			,Status=@Status
			
			Where ([MemberID] = @MemberID)
			
   End	
else
   Begin
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
           (@Id
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
    End      

