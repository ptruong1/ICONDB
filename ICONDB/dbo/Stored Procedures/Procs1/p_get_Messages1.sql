CREATE PROCEDURE [dbo].[p_get_Messages1]
@facilityID	int, -- Required
@InmateID	varchar(12),
@fromDate	smalldatetime,
@toDate	smalldatetime
AS
SET nocount on 
If(@InmateID <>'' and @fromDate <> '' and @toDate <>'')
	select t1.MailboxID  ,MessageID, t1.InmateID, FirstName, LastName , t1.status, MessengerNo as [Caller ID], MessengerNo as [Caller Account],MessageDate ,MessageName 
	from tblMailBox  t1  with(nolock) , tblMailboxDetail t2  with(nolock), tblInmate  t3  with(nolock)
	  where t1.MailBoxID = t2.MailBoxID and t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID  and t1.FacilityID =@facilityID and   t1.InmateID= @InmateID	
	and MessageDate >= @fromDate and   MessageDate  <= dateadd(d,1,@toDate) 
	order by   t1.MailboxID  ,MessageID
Else If(@InmateID <>'' and @fromDate <> ''  )
	select t1.MailboxID  ,MessageID, t1.InmateID, FirstName, LastName , t1.status, MessengerNo as [Caller ID], MessengerNo as [Caller Account],MessageDate ,MessageName 
	from tblMailBox  t1  with(nolock) , tblMailboxDetail t2  with(nolock), tblInmate  t3  with(nolock)
	  where t1.MailBoxID = t2.MailBoxID and t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID  and t1.FacilityID =@facilityID and   t1.InmateID= @InmateID	
	and MessageDate >= @fromDate 
	order by   t1.MailboxID  ,MessageID
Else  If(@InmateID <>''  and @toDate <>'')
	select t1.MailboxID  ,MessageID, t1.InmateID, FirstName, LastName , t1.status, MessengerNo as [Caller ID], MessengerNo as [Caller Account],MessageDate ,MessageName 
	from tblMailBox  t1  with(nolock) , tblMailboxDetail t2  with(nolock), tblInmate  t3  with(nolock)
	  where t1.MailBoxID = t2.MailBoxID and t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID  and t1.FacilityID =@facilityID and   t1.InmateID= @InmateID	
	and   MessageDate  <= dateadd(d,1,@toDate) 
	order by   t1.MailboxID  ,MessageID
Else If(@InmateID <>'' )
	select t1.MailboxID  ,MessageID, t1.InmateID, FirstName, LastName , t1.status, MessengerNo as [Caller ID], MessengerNo as [Caller Account],MessageDate ,MessageName 
	from tblMailBox  t1  with(nolock) , tblMailboxDetail t2  with(nolock), tblInmate  t3  with(nolock)
	  where t1.MailBoxID = t2.MailBoxID and t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID  and t1.FacilityID =@facilityID and   t1.InmateID= @InmateID	
	order by   t1.MailboxID  ,MessageID
Else 
	select t1.MailboxID  ,MessageID, t1.InmateID, FirstName, LastName , t1.status, MessengerNo as [Caller ID], MessengerNo as [Caller Account],MessageDate ,MessageName 
	from tblMailBox  t1  with(nolock) , tblMailboxDetail t2  with(nolock), tblInmate  t3  with(nolock)
	  where t1.MailBoxID = t2.MailBoxID and t1.InmateID= t3.InmateID and t1.FacilityID = t3.facilityID  and t1.FacilityID =@facilityID 
	order by   t1.MailboxID  ,MessageID
