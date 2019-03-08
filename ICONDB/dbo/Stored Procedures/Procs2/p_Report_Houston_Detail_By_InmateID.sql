CREATE PROCEDURE [dbo].[p_Report_Houston_Detail_By_InmateID] 
(
	@facilityID	int,
	@fromDate	smalldatetime,
	@todate	smalldatetime
)
AS
	SET NOCOUNT ON;
	
	(select tblfacility.facilityID, tblfacility.Location, tblfacility.Address,tblfacility.Zipcode,tblfacility.State, 
tblcallsbilled.InmateID, RecordDate, tblCallType.Descript as Calltype ,  
		 CallRevenue,  
		Cast(tblCommrate.CommRate * 100 as Numeric(6,2)) as CommRate,
		(CASE PifPaid  when 0 then  CAST((( CallRevenue - (CallRevenue * isnull( BadDebtRate,0) ) )  *tblCommrate.CommRate)  as Numeric(12,2) ) 
		 Else 
		 CAST((( CallRevenue - (CallRevenue * isnull(BadDebtRate,0) ) -isnull(Pif,0) )  *tblCommrate.CommRate)  as Numeric(12,2) ) + isnull( PIf,0)     End)  as CommPaid,
		 '1' as recordCode
		from tblcallsbilled with(nolock),  tblCalltype  with(nolock), tblBilltype  with(nolock)  , 
		tblCommrate with(nolock), tblfacility with(nolock),
		tblANIs with(nolock), tblFacilityLocation with(nolock) 
		
		 WHERE
						tblcallsbilled.Billtype = tblBilltype.Billtype and
						 tblcallsBilled.errorcode = '0' and 
						tblcallsbilled.Calltype = tblCalltype.Abrev and
						tblcallsbilled.FacilityID=  tblCommrate.FacilityID and
						tblcallsbilled.Billtype =  tblCommrate.billtype and
						 tblcallsbilled.Calltype = tblCommrate.Calltype and
						 tblcallsbilled.fromNo = tblANIs.ANINo and
						 tblANIs.LocationID = tblFacilityLocation.LocationID and
					 	tblcallsbilled.facilityID	= 689  And
						tblfacility.facilityID = 689 and
						(RecordDate between @fromDate and dateadd(d,1,@todate) )   and convert (int,duration ) >5
						and  tono not in (select AuthNo from tblOfficeANI where  Billabe =0)
	
	Union
	
	select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
t1.inmateID,
t2.MessageDate,
t5.Descript as CallType,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
'50.00' as commrate, 
cast(Cast((t2.Charge * .50) as float) as Numeric(12,2)) as Commpaid,
'2' as recordCode 


from tblMailboxDetail t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblPrepaid t7 with(nolock) on t2.MessengerNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus  
left join tblfacility t9 with(nolock) on (t1.facilityID) = t9.facilityID
Where   
(t2.MessageDate between @fromDate and dateadd(d,1,@todate)) and 
t1.FacilityID = 689 and t2.MessageTypeID = '1' and
t1.FacilityID	= 689  	

Union

select t1.FacilityID,
t9.Location, 
t9.Address,
t9.Zipcode,
t9.State,
t1.inmateID,
t2.MessageDate,
t5.Descript as CallType,
Cast(cast(t2.Charge as float) as Numeric(12,2)) as CallRevenue, 
'50.00' as commrate, 
cast(Cast((t2.Charge * .50) as float) as Numeric(12,2)) as Commpaid,
'2' as recordCode  

from tblMailboxDetailF t2  with(nolock) 	
left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID 	
left join tblInmate  t3  with(nolock) on t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID 	
left join tblMessageRate t4  with(nolock) on t2.MessageTypeID = t4.MessageTypeID and t1.FacilityID = t4.FacilityID 	
left join tblMessageType t5  with(nolock) on t2.MessageTypeID = t5.MessageTypeID 	
left join tblMailboxF t6 with(nolock) on t2.MailBoxID = t6.MailBoxID 	
left join tblPrepaid t7 with(nolock) on t6.AccountNo = t7.PhoneNo 	
left join tblMessageStatus t8 with(nolock) on isnull(t2.MessageStatus,1) = t8.MessStatus
left join tblfacility t9 with(nolock) on (t1.facilityID) = t9.facilityID  
Where  
(t2.MessageDate between @fromDate and dateadd(d,1,@todate)) and 
t1.FacilityID = 689 and t2.MessageTypeID = '1' and
t1.FacilityID	= 689  	)
				
						 
	Order by recordCode, tblcallsbilled.inmateID, tblcallsbilled.RecordDate, tblCallType.Descript
	 
