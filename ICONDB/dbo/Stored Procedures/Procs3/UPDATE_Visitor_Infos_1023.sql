
CREATE PROCEDURE [dbo].[UPDATE_Visitor_Infos_1023]
(
	
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
	@Relationship  varchar(20),
	@RecordOpt char(1) ,
	@VisitorID int,
	@Approved Char(1),
	@UserName varchar(25),
	@DriverLicense varchar(25),
	@VNote varchar(150)
)
AS
	SET NOCOUNT OFF;
	Declare @ApprovedBy varchar(20), @ApprovedDate datetime;
	If (@Approved ='Y')
	 begin
		SET  @ApprovedBy = @UserName;
		SET   @ApprovedDate = getdate();
	 End

     Update tblVisitors
      Set 
      
           [Address] = @Address
           ,[City] = @City
           ,[State] = @State
           ,[Zipcode] = @ZipCode
           ,[Phone1] = @Phone1
           ,[Phone2] = @Phone2
           ,[Email] = @Email
           ,[InmateID] = @InmateID
           ,[RelationshipID] = @RelationshipID
           ,[Relationship] = @Relationship
           ,[RecordOpt] = @RecordOpt
           ,[ModifyDate]= GETDATE()
           ,[Approved] = @Approved
           ,[UserName] = @UserName
           ,[DriverLicense] = @DriverLicense
           ,[VNote] = @VNote
		   ,ApprovedBy = @ApprovedBy
		   ,ApprovedDate = @ApprovedDate
           
           where visitorID = @VisitorID and 
                 FacilityID = @FacilityID
      
