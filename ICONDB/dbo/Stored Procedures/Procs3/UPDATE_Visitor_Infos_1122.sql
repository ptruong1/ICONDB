
CREATE PROCEDURE [dbo].[UPDATE_Visitor_Infos_1122]
(
		
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
      
           
            [Phone2] = @Phone2
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
                 FacilityID = @FacilityID;
      
