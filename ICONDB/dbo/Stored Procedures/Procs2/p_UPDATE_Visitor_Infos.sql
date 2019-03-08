
CREATE PROCEDURE [dbo].[p_UPDATE_Visitor_Infos]
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
	@VNote varchar(150),
	@StateId smallint
	
	)
AS
	SET NOCOUNT OFF;

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
           ,[StateID] = @StateID
		  
           
           where visitorID = @VisitorID and 
                 FacilityID = @FacilityID
      
