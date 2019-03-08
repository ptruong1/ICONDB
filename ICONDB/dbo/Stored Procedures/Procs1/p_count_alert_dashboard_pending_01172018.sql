CREATE PROCEDURE [dbo].[p_count_alert_dashboard_pending_01172018]
@facilityID int,
@authID int
 AS
 Declare @temp table(totalvisitor int, totalvideovisit int, totalmessage int, totalinmatekite int, totalmedicalkite int, totalgrievance  int, totallegalform int)
 if (Select FormsOpt from tblFacilityOption where facilityID = @facilityID) > 0
	 begin
		 Insert @temp
		 
			--visitors
			  select (select count(*)  from tblVisitors  V, tblInmate I, tblVisitorStatus s
				where V.FacilityID =478 and V.Approved = 'P' and v.InmateID = I.InmateID and V.Approved = S.Status and  V.FacilityID = I.FacilityID),
			--video Visit
			(select count(*) as videovisitcount from tblVisitEnduserSchedule with(nolock) where FacilityID =@facilityID		
																								and (select isnull(tblAuthVideoVisitTab.[Utilities], 1) from tblAuthVideoVisitTab where AuthID =@authID) >0
																								and status =1),
			--message approval
		    (select(select COUNT(*) 
						from tblMailboxDetail t2  with(nolock)  left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 
						Where    t1.FacilityID = @facilityID 
						--and ((t2.MessageTypeID <> 4) or (t2.MessageTypeID = 4 and VideoStatus = 2)) 
						and (case 
								when t2.MessageTypeID =1 then (select VoiceMailApprove from tblAuthMessageTab where AuthID =@authID)
								when t2.MessageTypeID =2 then (select EmailApprove from tblAuthMessageTab where AuthID =@authID)
								
								when t2.MessageTypeID =4  and VideoStatus = 2 then (select VideoMessageApprove from tblAuthMessageTab where AuthID =@authID)
								when t2.MessageTypeID =5 then (select PictureExchangeApprove from tblAuthMessageTab where AuthID =@authID)
								 end) =1		
						and MessageStatus =1
					
						)
			+		
			(select COUNT(*) 
					from tblMailboxDetailF t2  with(nolock)  left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID
					Where    t1.FacilityID = @facilityID
					 and (case 
								when t2.MessageTypeID =1 then (select VoiceMailApprove from tblAuthMessageTab where AuthID =@authID)
								when t2.MessageTypeID =2 then (select EmailApprove from tblAuthMessageTab where AuthID =@authID)
								
								when t2.MessageTypeID =4  and VideoStatus = 2 then (select VideoMessageApprove from tblAuthMessageTab where AuthID =@authID)
								when t2.MessageTypeID =5 then (select PictureExchangeApprove from tblAuthMessageTab where AuthID =@authID)
								 end) =1		
						and MessageStatus =1)
					 ),
			--Forms		
			(select count(*) as totalinmatekite from tblInmateRequestForm R 
												inner join tblInmate I on R.FacilityID = I.FacilityID and R.InmateID = I.InmateID
												where R.FacilityID =@facilityID  and I.Status =1 
												and (select isnull(tblAuthFormTab.[InmateKite], 1) from tblAuthFormTab where AuthID =@authID) =1
												and R.Status = (CASE when @facilityID=796 then 20 else 1 end)),									
			(select count(*) as totalmedicalkite from tblMedicalKiteForm M inner join tblInmate I on M.FacilityID = I.FacilityID and M.InmateID = I.InmateID
												where M.FacilityID =@facilityID and I.Status =1 
												and (select isnull(tblAuthFormTab.[MedicalKite], 1) from tblAuthFormTab where AuthID =@authID) =1
												and M.Status = (CASE when @facilityID=796 then 20 else 1 end)),
			 (select count(*) as totalgrievance from tblGrievanceForm G inner join tblInmate I on G.FacilityID = I.FacilityID and G.InmateID = I.InmateID
												 where G.FacilityID =@facilityID and I.Status =1 
												 and (select isnull(tblAuthFormTab.[Grievance], 1) from tblAuthFormTab where AuthID =@authID) =1
												 and G.Status = (CASE when @facilityID=796 then 20 else 1 end)), 
			 (select count(*) as totallegalform from tblInmateLegalRequest L inner join tblInmate I on L.FacilityID = I.FacilityID and L.InmateID = I.InmateID
  											 where L.FacilityID =@facilityID 
  											 and (select isnull(tblAuthFormTab.[LegalForm], 1) from tblAuthFormTab where AuthID =@authID) =1
  											 and I.Status =1 and L.Status = (CASE when @facilityID=796 then 20 else 1 end))
						
	 end
else
	begin
		 Insert @temp
			 select (select count(*)  from tblVisitors V, tblInmate I,[tblVisitorStatus] S  where V.FacilityID =@facilityID and Approved = 'P' and  V.InmateID = I.InmateID and V.FacilityID = I.FacilityID and V.Approved = S.Status),
		    (select count(*) as videovisitcount from tblVisitEnduserSchedule with(nolock) where FacilityID =@facilityID and status =1),
		    (select(select COUNT(*) 
						from tblMailboxDetail t2  with(nolock)  left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 
						Where    t1.FacilityID = @facilityID and ((t2.MessageTypeID <> 4) or (t2.MessageTypeID = 4 and VideoStatus = 2)) and MessageStatus =1)
			+		
			(select COUNT(*) 
					from tblMailboxDetailF t2  with(nolock)  left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID
					Where    t1.FacilityID = @facilityID and ((t2.MessageTypeID <> 4) or (t2.MessageTypeID = 4 and VideoStatus = 2)) and MessageStatus =1)),
			
			 0 as totalinmatekite,									
			0 as totalmedicalkite,
			0 as totalgrievance, 
			0 as totallegalform 
	 end
		
select * from @temp
	 

