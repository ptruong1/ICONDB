-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Visitors_For_PAV]
(
		@facilityID int,
		@VLastName varchar(25)
        )
AS
			
	SET NOCOUNT OFF;
	
	
	  SELECT [VLastName], [VFirstName], [Address], [City], [State], [Zipcode], [Phone1], 
	  [InmateID], [FacilityID], [RelationShipID], [RelationShip], VisitorID 
	  FROM [tblVisitors] 
	  where VLastName like  @VLastName +'%' and FacilityID = @facilityId
 

