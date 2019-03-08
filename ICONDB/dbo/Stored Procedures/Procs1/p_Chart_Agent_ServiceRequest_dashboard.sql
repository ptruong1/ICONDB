 --=============================================
 --Author:		<Author,,Name>
 --Create date: <Create Date,,>
 --Description:	<Description,,>
 --=============================================
CREATE PROCEDURE [dbo].[p_Chart_Agent_ServiceRequest_dashboard]
@FacilityID  int ,
@AgentID   int,
@day varchar(11)

 AS
 
select IsNull((select  count(tblTroubleTicket.statusID)  from tblTroubleTicket 
				Full JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
				where CreateDate >=DATEADD(day, -29, getdate() )and tblTroubleTicket.statusID ='1' and 
				facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
				group by Descript),0) as Submitted, 
		IsNull((select  count(tblTroubleTicket.statusID)
				 from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
				where CreateDate >=DATEADD(day, -29, getdate() )and tblTroubleTicket.statusID ='2' and 
				facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
				group by Descript),0) as 'Open',
		IsNull((select  IsNull(count(tblTroubleTicket.statusID),0) from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
			where CreateDate >=DATEADD(day, -29, getdate() )and tblTroubleTicket.statusID ='3' and 
			facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
			group by Descript),0) as Resolved,
		IsNull((select IsNull(count(tblTroubleTicket.statusID),0) from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
			where CreateDate >=DATEADD(day, -29, getdate() )and tblTroubleTicket.statusID ='4' and 
			facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
			group by Descript),0) as Monitoring	


