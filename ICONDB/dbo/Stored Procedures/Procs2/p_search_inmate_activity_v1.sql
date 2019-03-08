-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_inmate_activity_v1]
@FacilityID int,
@InmateID	varchar(12),
@FirstName	varchar(25),
@LastName   varchar(25),
@FromDate	varchar(15),
@ToDate		varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare  @InmateAct table (RecordID varchar(34), InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, CommunityType tinyint, StationID varchar(25), ContactPhone varchar(18), Duration smallint, CommStatus tinyint) ;
	
If( @InmateID = '')
 begin
		if(@FirstName <> '' and @LastName <>''   and @FromDate <>'' and @todate<>'' )
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock) where inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
				  and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
			 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where  facilityID = @facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%') 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate);
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.inmateID in (select InmateID from  tblInmate where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate);	 
	     end 
		
		else if(@FirstName <> ''  and @FromDate <>'' and @todate<>'')
		  begin
	        
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock) where inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  )
				  and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
			 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock) where  facilityID = @facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  )
				and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  ) 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate);
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a , tblMailBox b where a.mailboxID = b.MailboxID and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%' )
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%' )
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate);	 
	     end 
		else if(@LastName <>''  and @FromDate <>'' and @todate<>'' ) 
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and  lastName like @LastName +'%')
				  and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
			 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock) where  facilityID = @facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID  AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID   AND lastName like @LastName +'%') 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate);
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID   AND lastName like @LastName +'%')
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.inmateID in (select InmateID from  tblInmate where facilityID =@facilityID   AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate);	 
	     end 
		else if( @FromDate <>'' and @todate<>'' ) 
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where 
				   facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate);
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				--select  (CASE MessageTypeID when 1 then [Message]  when 4 then [Message]  when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,30, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID 
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate);	 
	     end 
        else if( @FromDate <>''  ) 
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where 
				   facilityID = @facilityID and RecordDate>=@FromDate ; 	   
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and RecordDate>=@FromDate ; 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID 
				and Apmdate >=@FromDate ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID 
					and b.facilityID =@facilityID and MessageDate >=@FromDate ;
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  
				and RecordDate>=@FromDate ;	 
	     end  
		 else if(  @todate<>'' ) 
		  begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where 
				   facilityID = @facilityID and RecordDate <= dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where facilityID = @facilityID  and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID,isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID 
				and  Apmdate <=dateadd(d,1,@toDate);
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID 
					and b.facilityID =@facilityID  and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  
				and  RecordDate <= dateadd(d,1,@toDate);	 
	     end   
	end
else
 begin
	If(@InmateID <> '' and @FromDate <>'' and @todate<>'') 
	 begin
	    
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where inmateID = @InmateID and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where inmateID = @InmateID and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and InmateID =@InmateID and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate);
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID =@InmateID and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.InmateID= @InmateID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	
	 
	 end
	else if (@InmateID <> '' and @FromDate <>'') 
	 begin
		insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone, Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where inmateID = @InmateID and facilityID = @facilityID and RecordDate>=@FromDate ; 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where inmateID = @InmateID and facilityID = @facilityID and RecordDate>=@FromDate ; 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and InmateID =@InmateID and Apmdate >=@FromDate;
		
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a  with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID =@InmateID and b.facilityID =@facilityID and MessageDate >=@FromDate ;
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.InmateID= @InmateID and RecordDate>=@FromDate ; 	

	 
	 end
	 else if (@InmateID <> '' ) 
	 begin
		
		insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where inmateID = @InmateID and facilityID = @facilityID  ; 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where inmateID = @InmateID and facilityID = @facilityID  ; 
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and InmateID =@InmateID;
	   
	    insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID =@InmateID and b.facilityID =@facilityID ;
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b  with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID and b.InmateID= @InmateID; 	

	 end
	else if(@FromDate <>'' and @todate<>'') 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0' and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0' and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and Apmdate >=@FromDate and Apmdate <=@toDate;
	
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock) where a.mailboxID = b.MailboxID and  b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);

		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and  RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	

	 end
	else if(@FromDate <>'') 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0'and RecordDate>=@FromDate ; 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0' and RecordDate>=@FromDate ; 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName, ApmDate+ apmtime, 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and Apmdate >=@FromDate ;
	    insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and  b.facilityID =@facilityID and MessageDate >=@FromDate;
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and RecordDate>=@FromDate ; 	

	 end
    else if( @todate<>'') 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0' and  RecordDate <=dateadd(d,1,@toDate); 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0' and  RecordDate <=dateadd(d,1,@toDate); 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID,isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and  Apmdate <=@toDate;
	
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and  b.facilityID =@facilityID  and Messagedate <=dateadd(d,1,@toDate);
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '',isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID   and RecordDate <= dateadd(d,1,@toDate); 	

	 end
	else 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, CommStatus ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono, Duration,1 from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID <>'0' ;	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono, 0,0 from tblcallsUnbilled with(nolock) where facilityID = @facilityID and InmateID <>'0';	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), (case [status] when 5 then 1 else 0 end) from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID ;
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock) where a.mailboxID = b.MailboxID and b.facilityID =@facilityID ;
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  ; 	

	 end
 end
if(select count(*) from @InmateAct ) >0
	Update @inmateAct set InmateName = firstName +' ' + lastName 
		from tblInmate a with(nolock), @inmateAct b where a.InmateID = b.inmateID and a.facilityID = @facilityID and InmateName is null;

Select RecordID , InmateID ,InmateName, ActivityDate, Description as ActivityType, isnull( StationID,'')  StationID, ContactPhone , (CASE b.CommID when 5 then 'NA' else  [dbo].[fn_ConvertSecToMin] ( Duration) end)  Duration, 
			(CASE CommStatus when 0 then 'Incompleted' else 'Completed' end) As [ActivityStatus]
	from  @InmateAct a, tblCommunicationType b where a.CommunityType = b.commID
	Order by InmateID, ActivityDate;
     
    
END


