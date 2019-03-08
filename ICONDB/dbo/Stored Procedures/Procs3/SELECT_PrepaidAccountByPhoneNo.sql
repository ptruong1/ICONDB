




CREATE PROCEDURE [dbo].[SELECT_PrepaidAccountByPhoneNo]
(
	@PhoneNo varchar(12)
)
AS
	SET NOCOUNT ON;
SELECT     tblPrepaid.FacilityID, tblFacility.Location as [FacilityName],isnull( tblPrepaid.InmateID,0) InmateID, tblPrepaid.PhoneNo,isnull( tblPrepaid.PaymentTypeID,0) PaymentTypeID , isnull( tblPrepaid.RelationshipID, 0) RelationshipID , tblPrepaid.FirstName, tblPrepaid.LastName, tblPrepaid.MI, tblPrepaid.Address, 
                         tblPrepaid.City, tblPrepaid.State, tblPrepaid.ZipCode, tblPrepaid.Country, tblPrepaid.Balance,
tblPrepaid.Username,tblPrepaid.InputDate, tblPrepaid.ModifyDate,tblRelationShip.Descript as [RelationshipDesc],
tblPrepaid.status, tblStatus.Descrip as [StatusDesc], 
                         tblpaymentType.Descript as [PaymentTypeDesc]
FROM            tblPrepaid   with(nolock)  INNER JOIN
                         tblStatus   with(nolock) ON tblPrepaid.status = tblStatus.statusID INNER JOIN
                         tblpaymentType   with(nolock) ON (isnull(tblPrepaid.PaymentTypeID,0) = tblpaymentType.paymentTypeID)
						 INNER JOIN tblRelationShip ON (isnull(tblPrepaid.RelationshipID,99) = tblRelationShip.RelationshipID) 
					     INNER JOIN tblFacility On tblPrepaid.FacilityID = tblFacility.FacilityID
WHERE tblPrepaid.PhoneNo like  @PhoneNo +'%';

