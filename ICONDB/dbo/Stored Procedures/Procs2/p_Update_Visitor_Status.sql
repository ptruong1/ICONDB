
CREATE PROCEDURE [dbo].[p_Update_Visitor_Status]
(
	
	@facilityID int,
	@VisitorID int,
	@Approved Char(1),
	@ApprovedBy varchar(25),
	@UserIP varchar(25)
)
AS
	SET NOCOUNT OFF;
	 Declare @UserAction varchar(200)
	 Set @UserAction = 'Updated Visistor ID ' +  CAST (@VisitorID as varchar(15)) + ' by ' + @ApprovedBy
		EXEC  INSERT_ActivityLogs5   @FacilityID,23, @UserAction, @ApprovedBy, @UserIP
		
     Update tblVisitors
      Set 
               
           [ModifyDate]= GETDATE()
           ,[Approved] = @Approved
           ,[ApprovedBy] =@ApprovedBy
		   ,[ApprovedDate]= GETDATE()
           
           where visitorID = @VisitorID and 
                 FacilityID = @FacilityID and
                 Approved = 'P'
      
