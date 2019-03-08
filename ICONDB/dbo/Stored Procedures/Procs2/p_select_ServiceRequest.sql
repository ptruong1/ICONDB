
CREATE PROCEDURE [dbo].[p_select_ServiceRequest]
@FacilityID  int ,
@day varchar(11),
@statusID int

 AS
 if (@statusID =0)
 SELECT top 100 tblTroubleTicket.TicketID, tblTroubleTicket.TroubleSubject,tblTroubleTicket.TroubleNote,tblTroubleTicket.statusID,
							   tblTroubleTicket.ContactName, tblTroubleTicket.ContactPhone, tblTroubleTicket.ContactEmail,
								tblTroubleTicket.userName,tblTroubleTicket.CreateDate, tblTroubleTicket.TroubleDate,tblTroubleTicket.ResolveDate,
								tblTroubleTicketStatus.Descript AS StatusDesc, tblTroubleType.TroubleID AS TroubleID, tblTroubleType.Descript AS TypeDesc
		                        
		FROM tblTroubleTicket INNER JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID INNER JOIN
							   tblTroubleType ON tblTroubleTicket.TroubleID = tblTroubleType.TroubleID 
		WHERE FacilityID = @FacilityID 
		ORDER BY TicketID DESC
 else
 begin
		SELECT tblTroubleTicket.TicketID, tblTroubleTicket.TroubleSubject,tblTroubleTicket.TroubleNote,tblTroubleTicket.statusID,
							   tblTroubleTicket.ContactName, tblTroubleTicket.ContactPhone, tblTroubleTicket.ContactEmail,
								tblTroubleTicket.userName,tblTroubleTicket.CreateDate, tblTroubleTicket.TroubleDate,tblTroubleTicket.ResolveDate,
								tblTroubleTicketStatus.Descript AS StatusDesc, tblTroubleType.TroubleID AS TroubleID, tblTroubleType.Descript AS TypeDesc
		                        
		FROM tblTroubleTicket INNER JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID INNER JOIN
							   tblTroubleType ON tblTroubleTicket.TroubleID = tblTroubleType.TroubleID 
		WHERE FacilityID = @FacilityID and tblTroubleTicket.statusID =@statusID and CreateDate >=DATEADD(day, -29, getdate() )
end
