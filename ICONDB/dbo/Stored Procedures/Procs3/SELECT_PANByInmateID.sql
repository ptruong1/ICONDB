

CREATE PROCEDURE [dbo].[SELECT_PANByInmateID]
 @InmateID varchar(12) ,
 @FacilityID  int
AS
SET NOCOUNT ON
SELECT  tblPhones.RecordID, tblPhones.LastName, tblPhones.FirstName, 
		tblPhones.Address, tblPhones.City, tblPhones.State, tblPhones.RelationshipID, 
		tblPhones.ZipCode, tblRelationShip.Descript AS RelationshipName, tblPhones.phoneNo, 
		tblPhones.PIN, tblPhones.AlertToPhone, tblPhones.AlertToCell, tblPhones.AlertToEmail
FROM tblPhones INNER JOIN tblRelationShip
	 ON tblPhones.RelationshipID = tblRelationShip.RelationshipID 
WHERE tblPhones.InmateID = @InmateID And  tblPhones.FacilityID = @FacilityID

