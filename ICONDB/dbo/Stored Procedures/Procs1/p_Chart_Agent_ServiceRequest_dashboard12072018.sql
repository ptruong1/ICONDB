 --=============================================
 --Author:		<Author,,Name>
 --Create date: <Create Date,,>
 --Description:	<Description,,>
 --=============================================
CREATE PROCEDURE [dbo].[p_Chart_Agent_ServiceRequest_dashboard12072018]
@AgentID   int,
@day varchar(11),
@MasterUserGroupID int,
@UserGroupID int
 AS
 
 if @MasterUserGroupID = @UserGroupID
	 begin
		select IsNull((select  count(tblTroubleTicket.statusID)  from tblTroubleTicket 
				Full JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
				where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='1' and 
				facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
				group by Descript),0) as Submitted, 
		IsNull((select  count(tblTroubleTicket.statusID)
				 from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
				where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='2' and 
				facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
				group by Descript),0) as 'Open',
		IsNull((select  IsNull(count(tblTroubleTicket.statusID),0) from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
			where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='3' and 
			facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
			group by Descript),0) as Resolved,
		IsNull((select IsNull(count(tblTroubleTicket.statusID),0) from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
			where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='4' and 
			facilityID in(select facilityID from  tblFacility  with(nolock) WHERE AgentID = @AgentID and status =1) 
			group by Descript),0) as Monitoring	
	 end
else
	begin
		select IsNull((select  count(tblTroubleTicket.statusID)  from tblTroubleTicket 
				Full JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
				where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='1' and 
				facilityID in (select tblFacility.facilityID from  tblFacility join tblUserGroupFacility on tblFacility.FacilityID =tblUserGroupFacility.FacilityID   WHERE tblFacility.AgentID = @AgentID and status =1 and MasterUserGroupID=@MasterUserGroupID)
				group by Descript),0) as Submitted, 
		IsNull((select  count(tblTroubleTicket.statusID)
				 from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
				where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='2' and 
				facilityID in (select tblFacility.facilityID from  tblFacility join tblUserGroupFacility on tblFacility.FacilityID =tblUserGroupFacility.FacilityID   WHERE tblFacility.AgentID = @AgentID and status =1 and MasterUserGroupID=@MasterUserGroupID)
				group by Descript),0) as 'Open',
		IsNull((select  IsNull(count(tblTroubleTicket.statusID),0) from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
			where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='3' and 
			facilityID in (select tblFacility.facilityID from  tblFacility join tblUserGroupFacility on tblFacility.FacilityID =tblUserGroupFacility.FacilityID   WHERE tblFacility.AgentID = @AgentID and status =1 and MasterUserGroupID=@MasterUserGroupID)
			group by Descript),0) as Resolved,
		IsNull((select IsNull(count(tblTroubleTicket.statusID),0) from tblTroubleTicket right JOIN tblTroubleTicketStatus ON tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID
			where CreateDate >=DATEADD(month, -1, getdate())and tblTroubleTicket.statusID ='4' and 
			facilityID in (select tblFacility.facilityID from  tblFacility join tblUserGroupFacility on tblFacility.FacilityID =tblUserGroupFacility.FacilityID   WHERE tblFacility.AgentID = @AgentID and status =1 and MasterUserGroupID=@MasterUserGroupID)
			group by Descript),0) as Monitoring	
	end




