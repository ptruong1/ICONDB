
CREATE PROCEDURE [dbo].[p_Chart_facility_LiveCommunicationReport1]
@FacilityID  int, 
@Last15Days varchar(10)

 AS
 --CONVERT(CHAR(10),RecordDate,101) as days, count(CallRevenue) as CallCount, 1 as recordID     
 select  CONVERT(CHAR(10),t2.MessageDate,101) as days, count (t2.MessageID) as countmessage,1 as id
 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =1 and MessageDate between @Last15Days and  dateadd(d,1,GETDATE())
 group by CONVERT(CHAR(10),t2.MessageDate,101)
 
 union
 
 select CONVERT(CHAR(10),t2.MessageDate,101) as days,  count (t2.MessageID) as countmessage, 2 as id
 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =2 and MessageDate between @Last15Days and  dateadd(d,1,GETDATE())
 group by CONVERT(CHAR(10),t2.MessageDate,101)
 
 union
 
 select  CONVERT(CHAR(10),t2.MessageDate,101) as days,count (t2.MessageID) as countmessage, 4 as id
 from tblMailboxDetail t2  with(nolock) 	left join tblMailBox  t1  with(nolock) on t1.MailBoxID = t2.MailBoxID 	
 where FacilityID = @FacilityID and MessageTypeID =4 and MessageDate between @Last15Days and  dateadd(d,1,GETDATE())
 group by CONVERT(CHAR(10),t2.MessageDate,101)
  order by id, days desc
