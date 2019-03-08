
CREATE PROCEDURE [dbo].[p_UPDATE_Visitor_Infos_03132018]
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
	@ApprovedApm bit,
	@VNote varchar(150)
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
		   ,[ApprovedApm] = @ApprovedApm
           ,[VNote] = @VNote
           
           
           where visitorID = @VisitorID and 
                 FacilityID = @FacilityID
      
	Update tblEndusers
	set Email =@Email