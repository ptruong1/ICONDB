
CREATE PROCEDURE [dbo].[p_Update_Appointment_Status]
(
	
	@facilityID int,
	@ApmNo int,
	@ApprovedBy varchar(25)
	
)
AS
	SET NOCOUNT OFF;
	 Declare @UserAction varchar(200)
	 --Set @UserAction = 'Updated Visistor ID ' +  CAST (@VisitorID as varchar(15)) + ' by ' + @ApprovedBy
		--EXEC  INSERT_ActivityLogs5   @FacilityID,23, @UserAction, @ApprovedBy, @UserIP
		
     Update [tblVisitEnduserSchedule]
      Set 
         [ApprovedTime] = getdate()
		,[ApprovedBy] = @ApprovedBy
        ,[status] = 2     
                      
           where ApmNo = @ApmNo and 
                 FacilityID = @FacilityID 
                 
      
