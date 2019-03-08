
CREATE PROCEDURE [dbo].[p_Chart_Dashboard_EmailVoiceVideoMessage_ByMonth]
@FacilityID  int
 AS
declare @today date; 
declare @startDate date; 
set @today = CURRENT_TIMESTAMP;
set @startDate = dateadd(day, -(day(@today)) + 1, @today)
--(select CONVERT(CHAR(10),RecordDate,101) as days, count(CallRevenue) as CallCount, 1 as recordID     
-- from tblcallsBilled   WITH(NOLOCK) 
--		where RecordDate between @startDate and  dateadd(d,1,GETDATE()) and 
--             tblcallsBilled.errorcode = '0' and
--             tblcallsBilled.FacilityID = @FacilityID
--       group by CONVERT(CHAR(10),RecordDate,101)
                    
 (select CONVERT(CHAR(10),t2.MessageDate,101) as days, count (t2.MessageID) as countmessage,1 as id
	from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
	 where FacilityID = @FacilityID and 
	 MessageTypeID =1 and
	 t2.MessageDate between @startDate and  dateadd(d,1,GETDATE())
	 group by CONVERT(CHAR(10),t2.MessageDate,101)
 
 union
 
 select CONVERT(CHAR(10),t2.MessageDate,101) as days,  count (t2.MessageID) as countmessage, 2 as id
	 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
	 where FacilityID = @FacilityID and 
	 MessageTypeID =2 and
	 t2.MessageDate between @startDate and  dateadd(d,1,GETDATE()) 
	 group by CONVERT(CHAR(10),t2.MessageDate,101)
	 
 union
 
 select   CONVERT(CHAR(10),t2.MessageDate,101) as days,count (t2.MessageID) as countmessage, 4 as id
	 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
	 where FacilityID = @FacilityID and
	 MessageTypeID =4 and
	 t2.MessageDate between @startDate and  dateadd(d,1,GETDATE()) 
	 group by  CONVERT(CHAR(10),t2.MessageDate,101))
 order by id, days asc
  

