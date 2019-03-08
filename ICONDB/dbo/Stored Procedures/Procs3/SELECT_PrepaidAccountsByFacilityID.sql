








CREATE PROCEDURE [dbo].[SELECT_PrepaidAccountsByFacilityID]
(@FacilityID int)
AS
	SET NOCOUNT ON;
SELECT      tblPrepaid.FacilityID, tblFacility.Location as [FacilityName], tblPrepaid.InmateID, tblPrepaid.InmateName, tblPrepaid.PhoneNo, tblPrepaid.PaymentTypeID, tblPrepaid.RelationshipID, tblPrepaid.FirstName, tblPrepaid.LastName, tblPrepaid.MI, tblPrepaid.Address, 
                         tblPrepaid.City, tblPrepaid.State, tblPrepaid.ZipCode, tblPrepaid.Country, tblPrepaid.Balance,
tblPrepaid.Username,tblPrepaid.InputDate, tblPrepaid.ModifyDate,tblRelationShip.Descript as [RelationshipDesc],
tblPrepaid.status, tblStatus.Descrip as [StatusDesc], 
                         tblpaymentType.Descript as [PaymentTypeDesc]
FROM            tblPrepaid   with(nolock) INNER JOIN
                         tblStatus   with(nolock)  ON tblPrepaid.status = tblStatus.statusID INNER JOIN
                         tblpaymentType  with(nolock)  ON tblPrepaid.PaymentTypeID = tblpaymentType.paymentTypeID
						 INNER JOIN tblRelationShip ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID
						 INNER JOIN tblFacility ON tblPrepaid.FacilityID = tblFacility.FacilityID
WHERE tblPrepaid.FacilityID = @FacilityID
ORDER BY tblPrepaid.Inputdate DESC

