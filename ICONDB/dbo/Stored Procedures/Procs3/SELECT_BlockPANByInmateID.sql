

CREATE PROCEDURE [dbo].[SELECT_BlockPANByInmateID]
 @InmateID varchar(12) ,
 @FacilityID  int
AS
SET NOCOUNT ON
SELECT PhoneNo, PIN, UserName, inputDate, TimeLimited, tblBlockedPhonesByPIN.Descript as Descript, tblBlockedReason.description as BlockReason, 
		tblBlockedRequest.Descript as RequestReason, tblBlockedPhonesByPIN.ReasonID, tblBlockedPhonesByPIN.RequestID
FROM tblBlockedPhonesByPIN 
	inner join tblBlockedReason on tblBlockedPhonesByPIN.ReasonID = tblBlockedReason.ReasonID
	inner join tblBlockedRequest on tblBlockedPhonesByPIN.RequestID = tblBlockedRequest.RequestID
	 
WHERE tblBlockedPhonesByPIN.InmateID = @InmateID And  tblBlockedPhonesByPIN.FacilityID = @FacilityID
