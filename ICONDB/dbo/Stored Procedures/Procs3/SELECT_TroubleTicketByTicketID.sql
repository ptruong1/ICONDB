




CREATE PROCEDURE [dbo].[SELECT_TroubleTicketByTicketID]
( 
	@FacilityID int,
	@TicketID int
)
AS
	SET NOCOUNT ON;
SELECT        tblTroubleTicket.TicketID, tblTroubleTicket.FacilityID, tblTroubleTicket.TroubleID, tblTroubleTicket.TroubleSubject, tblTroubleTicket.TroubleNote, 
                         tblTroubleTicket.userName, tblTroubleTicket.ContactName, tblTroubleTicket.ContactEmail, tblTroubleTicket.ContactPhone, tblTroubleTicket.CreateDate, 
                         tblTroubleTicket.TroubleDate, tblTroubleTicket.ResolveDate, tblTroubleTicket.ResolveNote, tblTroubleTicket.statusID, 
                         tblTroubleTicketStatus.Descript AS StatusDesc, tblTroubleType.Descript AS TypeDesc, tblTroubleType.ResponseEmail
FROM            tblTroubleTicket   with(nolock)  INNER JOIN
                         tblTroubleTicketStatus    with(nolock) ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID INNER JOIN
                         tblTroubleType   with(nolock) ON tblTroubleTicket.TroubleID = tblTroubleType.TroubleID
WHERE FacilityID = @FacilityID AND TicketID = @TicketID

