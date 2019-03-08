-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_VisitorByInmate]
(
		@facilityID int,
		@InmateID varchar(12)
        )
AS
			
	SET NOCOUNT OFF;
	
	
	  SELECT [VLastName], [VFirstName], [Address], [City], [State], [Zipcode], [Phone1], 
	  [InmateID], [FacilityID], [RelationShipID], [RelationShip], VisitorID 
	  FROM [tblVisitors] 
	  WHERE (([FacilityID] = @FacilityID) AND ([InmateID] = @InmateID))
 

