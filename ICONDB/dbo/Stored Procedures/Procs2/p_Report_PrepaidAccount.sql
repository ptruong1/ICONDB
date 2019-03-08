




CREATE PROCEDURE [dbo].[p_Report_PrepaidAccount]
(
	@FacilityID int,
	@FromDate smalldatetime,
	@ToDate smalldatetime
)
AS
	SET NOCOUNT ON;

If (@FacilityID = 74  or @FacilityID = 75 ) 
Begin
	SELECT      tblPrepaid.FacilityID, tblFacility.Location as [FacilityName], tblPrepaid.InmateID, tblPrepaid.InmateName, tblPrepaid.PhoneNo, tblPrepaid.PaymentTypeID, tblPrepaid.RelationshipID, isnull(tblPrepaid.FirstName,'') FirstName , isnull(tblPrepaid.LastName,'') LastName, isnull(tblPrepaid.MI,'')  MI, tblPrepaid.Address, 
	                         tblPrepaid.City, tblPrepaid.State, tblPrepaid.ZipCode, tblPrepaid.Country, tblPrepaid.Balance,
	tblPrepaid.Username,tblPrepaid.InputDate, tblPrepaid.ModifyDate,tblRelationShip.Descript as [RelationshipDesc],
	tblPrepaid.status, tblStatus.Descrip as [StatusDesc], 
	                         tblpaymentType.Descript as [PaymentTypeDesc]
	FROM            tblPrepaid   with(nolock) INNER JOIN
	                         tblStatus   with(nolock)  ON tblPrepaid.status = tblStatus.statusID INNER JOIN
	                         tblpaymentType  with(nolock)  ON tblPrepaid.PaymentTypeID = tblpaymentType.paymentTypeID
							 INNER JOIN tblRelationShip ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID
							 INNER JOIN tblFacility ON tblPrepaid.FacilityID = tblFacility.FacilityID
	WHERE tblPrepaid.FacilityID in(74,75) and tblPrepaid.inputdate >= @FromDate and tblPrepaid.inputdate <=  dateadd(d,1,@ToDate)  and  tblPrepaid.Balance >=0
	ORDER BY tblPrepaid.Inputdate DESC
end
else
 begin
	SELECT      tblPrepaid.FacilityID, tblFacility.Location as [FacilityName], tblPrepaid.InmateID, tblPrepaid.InmateName, tblPrepaid.PhoneNo, tblPrepaid.PaymentTypeID, tblPrepaid.RelationshipID, isnull(tblPrepaid.FirstName,'') FirstName , isnull(tblPrepaid.LastName,'') LastName, isnull(tblPrepaid.MI,'')  MI, tblPrepaid.Address, 
	                         tblPrepaid.City, tblPrepaid.State, tblPrepaid.ZipCode, tblPrepaid.Country, tblPrepaid.Balance,
	tblPrepaid.Username,tblPrepaid.InputDate, tblPrepaid.ModifyDate,tblRelationShip.Descript as [RelationshipDesc],
	tblPrepaid.status, tblStatus.Descrip as [StatusDesc], 
	                         tblpaymentType.Descript as [PaymentTypeDesc]
	FROM            tblPrepaid   with(nolock) INNER JOIN
	                         tblStatus   with(nolock)  ON tblPrepaid.status = tblStatus.statusID INNER JOIN
	                         tblpaymentType  with(nolock)  ON tblPrepaid.PaymentTypeID = tblpaymentType.paymentTypeID
							 INNER JOIN tblRelationShip ON tblPrepaid.RelationshipID = tblRelationShip.RelationshipID
							 INNER JOIN tblFacility ON tblPrepaid.FacilityID = tblFacility.FacilityID
	WHERE tblPrepaid.FacilityID = @FacilityID and tblPrepaid.inputdate >= @FromDate and tblPrepaid.inputdate <=  dateadd(d,1,@ToDate)  and  tblPrepaid.Balance >=0
	ORDER BY tblPrepaid.Inputdate DESC
 end

