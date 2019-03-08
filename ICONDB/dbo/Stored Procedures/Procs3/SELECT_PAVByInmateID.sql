

CREATE PROCEDURE [dbo].[SELECT_PAVByInmateID]
 @InmateID varchar(12) ,
 @FacilityID  int
AS
SET NOCOUNT ON
SELECT  [VLastName], [VFirstName], [Address], [City], [State], [Zipcode], A.RelationshipID, A.Relationship, I.VisitorID 
FROM [tblVisitorInmate] I
INNER JOIN tblVisitors A
	 ON I.VisitorID = A.VisitorID

WHERE I.InmateID = @InmateID And  
      I.FacilityID = @FacilityID

