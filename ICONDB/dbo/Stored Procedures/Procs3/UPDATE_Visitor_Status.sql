
CREATE PROCEDURE [dbo].[UPDATE_Visitor_Status]
(
	
	@facilityID int,
	@VisitorID int,
	@Approved Char(1)
)
AS
	SET NOCOUNT OFF;

     Update tblVisitors
      Set 
               
           [ModifyDate]= GETDATE()
           ,[Approved] = @Approved
           
           where visitorID = @VisitorID and 
                 FacilityID = @FacilityID and
                 Approved = 'P'
      
