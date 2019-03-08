
CREATE PROCEDURE [dbo].[p_Chart_Dashboard_EmailVoiceVideoMessage_ByWeek]
@FacilityID  int
 AS

 (select DATENAME(weekday, t2.MessageDate) as days, count (t2.MessageID) as countmessage,1 as id,
	( case DATENAME(weekday, t2.MessageDate) 
		WHEN 'Monday' THEN 1 
		WHEN 'Tuesday' THEN 2
		WHEN 'Wednesday' THEN 3
		WHEN 'Thursday' THEN 4
		WHEN 'Friday' THEN 5
		WHEN 'Saturday' THEN 6
		WHEN 'Sunday' THEN 7
	 end ) as ConvertdaytoNumber
  from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =1 and t2.MessageDate between DATEADD(week, DATEDIFF(day, 0, GETDATE())/7, 0) and  dateadd(d,1,GETDATE())
 group by DATENAME(weekday, t2.MessageDate)
 
 union
 
 select DATENAME(weekday, t2.MessageDate) as days,  count (t2.MessageID) as countmessage, 2 as id,
 ( case DATENAME(weekday, t2.MessageDate) 
		WHEN 'Monday' THEN 1 
		WHEN 'Tuesday' THEN 2
		WHEN 'Wednesday' THEN 3
		WHEN 'Thursday' THEN 4
		WHEN 'Friday' THEN 5
		WHEN 'Saturday' THEN 6
		WHEN 'Sunday' THEN 7
	 end ) as ConvertdaytoNumber
 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =2 and t2.MessageDate between DATEADD(week, DATEDIFF(day, 0, GETDATE())/7, 0) and  dateadd(d,1,GETDATE()) 
 group by DATENAME(weekday, t2.MessageDate)
 
 union
 
 select   DATENAME(weekday, t2.MessageDate) as days,count (t2.MessageID) as countmessage, 4 as id,
 ( case DATENAME(weekday, t2.MessageDate) 
		WHEN 'Monday' THEN 1 
		WHEN 'Tuesday' THEN 2
		WHEN 'Wednesday' THEN 3
		WHEN 'Thursday' THEN 4
		WHEN 'Friday' THEN 5
		WHEN 'Saturday' THEN 6
		WHEN 'Sunday' THEN 7
	 end ) as ConvertdaytoNumber
 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =4 and t2.MessageDate between DATEADD(week, DATEDIFF(day, 0, GETDATE())/7, 0) and  dateadd(d,1,GETDATE()) 
 group by  DATENAME(weekday, t2.MessageDate))
 order by id, ConvertdaytoNumber asc
  

