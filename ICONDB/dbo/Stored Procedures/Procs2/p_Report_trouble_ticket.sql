


CREATE PROCEDURE [dbo].[p_Report_trouble_ticket] 
@FacilityID int,  --Required
@troubleType  int,
@troubleStatus	int,
@FromDate	smalldatetime,  --Required
@ToDate	smalldatetime  --Required
AS

If( @troubleType > 0 and  @troubleStatus > 0 )
	SELECT  TicketID ,FacilityID, tblTroubleType.Descript as TroubleType,TroubleSubject,TroubleNote ,ContactName,ContactEmail,ContactPhone,CreateDate,TroubleDate,
	tblTroubleTicketStatus.Descript as Status   FROM  tblTroubleTicket  with(nolock) ,  tblTroubleType  with(nolock)  , tblTroubleTicketStatus  with(nolock) 
	WHERE  tblTroubleTicket.TroubleID = tblTroubleType.TroubleID and 
		   tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID  and
		   FacilityID= @FacilityID and 
		  tblTroubleType.troubleID=  @troubleType  and
	                 tblTroubleTicketStatus.statusID	= @troubleStatus  and
		    TroubleDate  >  @FromDate and
		    TroubleDate  <=       @ToDate

Else If( @troubleType > 0 )
	SELECT  TicketID ,FacilityID, tblTroubleType.Descript as TroubleType,TroubleSubject,TroubleNote ,ContactName,ContactEmail,ContactPhone,CreateDate,TroubleDate,
	tblTroubleTicketStatus.Descript as Status   FROM  tblTroubleTicket  with(nolock) ,  tblTroubleType  with(nolock)  , tblTroubleTicketStatus  with(nolock) 
	WHERE  tblTroubleTicket.TroubleID = tblTroubleType.TroubleID and 
		   tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID  and
		   FacilityID= @FacilityID and 
	                   tblTroubleType.troubleID=  @troubleType  and
		    TroubleDate  >  @FromDate and
		    TroubleDate  <=       @ToDate	
Else If ( @troubleStatus >0)
	SELECT  TicketID ,FacilityID, tblTroubleType.Descript as TroubleType,TroubleSubject,TroubleNote ,ContactName,ContactEmail,ContactPhone,CreateDate,TroubleDate,
	tblTroubleTicketStatus.Descript as Status   FROM  tblTroubleTicket  with(nolock) ,  tblTroubleType  with(nolock)  , tblTroubleTicketStatus  with(nolock) 
	WHERE  tblTroubleTicket.TroubleID = tblTroubleType.TroubleID and 
		   tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID  and
		   FacilityID= @FacilityID and 
	                 tblTroubleTicketStatus.statusID	= @troubleStatus  and
		    TroubleDate  >  @FromDate and
		    TroubleDate  <=       @ToDate	
Else
	SELECT  TicketID ,FacilityID, tblTroubleType.Descript as TroubleType,TroubleSubject,TroubleNote ,ContactName,ContactEmail,ContactPhone,CreateDate,TroubleDate,
	tblTroubleTicketStatus.Descript as Status   FROM  tblTroubleTicket  with(nolock) ,  tblTroubleType  with(nolock)  , tblTroubleTicketStatus  with(nolock) 
	WHERE  tblTroubleTicket.TroubleID = tblTroubleType.TroubleID and 
		   tblTroubleTicket.statusID = tblTroubleTicketStatus.statusID  and
		   FacilityID= @FacilityID and
		    TroubleDate  >  @FromDate and
		    TroubleDate  <=       @ToDate



