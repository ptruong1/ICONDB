
CREATE PROCEDURE [dbo].[p_Chart_Dashboard_EmailVoiceVideoMessage_ByHour]
@FacilityID  int
 AS
 select DATEPART(hour,t2.MessageDate)as Hours, count (t2.MessageID) as countmessage,1 as id
  from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =1 and 
 --t2.MessageDate between '12/21/2015' and dateadd(d,1,'12/21/2015')
 convert(varchar(10), t2.MessageDate, 102)  = convert(varchar(10), getdate(), 102) 
  group by DATEPART(hour,t2.MessageDate)
 
 union
 
  select tem.Hours, count (*) as countmessage, 2 as id
from
(select DATEPART(hour,t2.MessageDate) as Hours
from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 
Where    convert(varchar(10), t2.MessageDate, 102)  = convert(varchar(10), getdate(), 102)  and
t1.FacilityID = @FacilityID and t2.MessageTypeID = '2'

Union all
 select  DATEPART(hour,t2.MessageDate) as Hours
from tblMailboxDetailF t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.SenderMailBoxID	

Where   convert(varchar(10), t2.MessageDate, 102)  = convert(varchar(10), getdate(), 102)  and t1.FacilityID = @FacilityID and t2.MessageTypeID = '2' ) as tem
group by Hours
  
 union
 
 select   DATEPART(hour,t2.MessageDate)as Hours,count (t2.MessageID) as countmessage, 4 as id
 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =4 and
   convert(varchar(10), t2.MessageDate, 102)  = convert(varchar(10), getdate(), 102) 
 group by  DATEPART(hour,t2.MessageDate)
 order by id, Hours asc
  

