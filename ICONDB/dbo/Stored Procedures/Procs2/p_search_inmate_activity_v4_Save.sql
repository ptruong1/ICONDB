-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_inmate_activity_v4_Save]
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
	Declare  @InmateAct table (RecordID varchar(34), InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, CommunityType tinyint, StationID varchar(25), ContactPhone varchar(18),PhoneType tinyInt default 3, ContactName  varchar(50), Duration smallint, CommStatus tinyint, RecordOpt varchar(1) Default 'Y', ActivityStatus varchar(25)) ;
	
If( @InmateID = '')
 begin
		if(@FirstName <> '' and @LastName <>''   and @FromDate <>'' and @todate<>'' )
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , PhoneType, Duration, CommStatus ,RecordOpt ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, (CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0, (Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock) where inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
				  and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
			 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone , PhoneType, Duration, CommStatus, RecordOpt ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end),0,errorType,'N' from tblcallsUnbilled with(nolock)  where  facilityID = @facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus , RecordOpt ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), [status], RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%') 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate) ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus, RecordOpt ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1,RecordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.inmateID in (select InmateID from  tblInmate where facilityID =@facilityID and Firstname like @FirstName +'%'  AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate) ;	 
	     end 
		
		else if(@FirstName <> ''  and @FromDate <>'' and @todate<>'')
		  begin
	        --print 'TEST'
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone ,PhoneType, Duration, CommStatus,RecordOpt  ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, (CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock) where inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  )
				  and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate) ; 	   
			 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus,RecordOpt ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType,'N' from tblcallsUnbilled with(nolock) where  facilityID = @facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  )
				and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt  ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), [status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%'  ) 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate) ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a , tblMailBox b where a.mailboxID = b.MailboxID and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%' )
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt  ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1 , RecordOpt  from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and Firstname like @FirstName +'%' )
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate) ;	 
	     end 
		else if(@LastName <>''  and @FromDate <>'' and @todate<>'' ) 
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone ,PhoneType, Duration, CommStatus,RecordOpt  ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, (CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0, (Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID and  lastName like @LastName +'%')
				  and facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate)  ; 	   
			 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock) where  facilityID = @facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID  AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0),[status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID   AND lastName like @LastName +'%') 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate) ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and b.inmateID in (select InmateID from  tblInmate with(nolock)  where facilityID =@facilityID   AND lastName like @LastName +'%')
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ,recordOpt) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1,recordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.inmateID in (select InmateID from  tblInmate where facilityID =@facilityID   AND lastName like @LastName +'%')
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate)  ;	 
	     end 
		else if( @FromDate <>'' and @todate<>'' ) 
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone ,phoneType, Duration, CommStatus , RecordOpt ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, (CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where 
				   facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate) ; 	   
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), [status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID 
				and Apmdate >=@FromDate and Apmdate <=dateadd(d,1,@toDate) ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				--select  (CASE MessageTypeID when 1 then [Message]  when 4 then [Message]  when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,30, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID 
					and b.facilityID =@facilityID and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus , RecordOpt) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1 ,RecordOpt  from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  
				and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate) ;	 
	     end 
        else if( @FromDate <>''  ) 
		 begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone ,PhoneType, Duration, CommStatus, RecordOpt ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono, (CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where 
				   facilityID = @facilityID and RecordDate>=@FromDate ; 	   
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and RecordDate>=@FromDate ; 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ,RecordOpt) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), [status], RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID 
				and Apmdate >=@FromDate  ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID 
					and b.facilityID =@facilityID and MessageDate >=@FromDate ;
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '',  isnull(duration,0), 1, RecordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  
				and RecordDate>=@FromDate ;	 
	     end  
		 else if(  @todate<>'' ) 
		  begin
	    
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus, RecordOpt ) 
				select RecordID, InmateID, RecordDate, 1, fromNo,tono,(CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where 
				   facilityID = @facilityID and RecordDate <= dateadd(d,1,@toDate) ; 	   
			insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
				select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock)  where facilityID = @facilityID  and RecordDate <=dateadd(d,1,@toDate); 	   
			insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ,RecordOpt) 
				select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID,isnull(visitDuration,0),[status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID 
				and  Apmdate <=dateadd(d,1,@toDate)  ;
			insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
				select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
					from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID 
					and b.facilityID =@facilityID  and Messagedate <=dateadd(d,1,@toDate);
			 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
				select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1 ,RecordOpt  from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
				where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  
				and  RecordDate <= dateadd(d,1,@toDate) ;	 
	     end   
	end
else
 begin
	
	if(@FromDate <>'' and @todate<>'') 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus,RecordOpt ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono,(CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID =@InmateID  and RecordDate>=@FromDate and RecordDate <=dateadd(d,1,@toDate) ; 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and InmateID =@InmateID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate); 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), [status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and Apmdate >=@FromDate and Apmdate <=@toDate  and InmateID =@InmateID  ;
	
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock) where a.mailboxID = b.MailboxID and  b.facilityID =@facilityID and b.InmateID =@InmateID  and MessageDate >=@FromDate and Messagedate <=dateadd(d,1,@toDate);

		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ,RecordOpt) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1,RecordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID  and b.InmateID =@InmateID and RecordDate>=@FromDate and RecordDate <= dateadd(d,1,@toDate) ; 	

	 end
	else if(@FromDate <>'') 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus,RecordOpt ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono,(CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0, (Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID =@InmateID and RecordDate>=@FromDate  ; 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and InmateID =@InmateID  and RecordDate>=@FromDate ; 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
			select ApmNo, InmateID,InmateName, ApmDate+ apmtime, 2, StationID, EnduserID, isnull(visitDuration,0), [status], RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and Apmdate >=@FromDate   ;
	    insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock)  , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and  b.facilityID =@facilityID and b.InmateID =@InmateID and MessageDate >=@FromDate;
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ,RecordOpt) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1,RecordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID and b.InmateID =@InmateID   and RecordDate>=@FromDate ; 	

	 end
    else if( @todate<>'') 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus,RecordOpt ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono,(CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID =@InmateID  and  RecordDate <=dateadd(d,1,@toDate) ; 	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock)  where facilityID = @facilityID and InmateID =@InmateID  and  RecordDate <=dateadd(d,1,@toDate); 	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID,isnull(visitDuration,0), [status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and InmateID =@InmateID and  Apmdate <=@toDate   ;
	
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock)  where a.mailboxID = b.MailboxID and  b.facilityID =@facilityID and b.InmateID =@InmateID   and Messagedate <=dateadd(d,1,@toDate);
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '',isnull(duration,0), 1,RecordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID and b.InmateID =@InmateID   and RecordDate <= dateadd(d,1,@toDate) ; 	

	 end
	else 
	 begin
	    insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType, StationID , ContactPhone,PhoneType , Duration, CommStatus,RecordOpt ) 
			select RecordID, InmateID, RecordDate, 1, fromNo,tono,(CASE billType when '01' then 1 when '03' then 2 when '05' then 2 else  3 End), Duration,0,(Case RecordFile when 'NA' then 'N' Else 'Y' end)  from tblcallsbilled with(nolock)  where facilityID = @facilityID and InmateID = @InmateID;	   
		 insert  @InmateAct  (RecordID , InmateID , ActivityDate, CommunityType,  StationID , ContactPhone,PhoneType , Duration, CommStatus ) 
			select isnull(RecordID,0), InmateID, RecordDate, 1, fromNo,tono,(CASE ResponseCode when '399' then 2 when '010' then 1 else 3 end), 0, errorType from tblcallsUnbilled with(nolock) where facilityID = @facilityID and InmateID = @InmateID;	   
		insert  @InmateAct  (RecordID , InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
			select ApmNo, InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), [status],RecordOpt from tblVisitEnduserSchedule with(nolock)  where FacilityID =@facilityID and InmateID= @InmateID  ;
		insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus ) 
			select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end), b.InmateID,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60, (CASE MessageStatus when 1 then 1 when 2 then 1 else 0 end)
				from tblMailBoxDetail a with(nolock) , tblMailBox b with(nolock) where a.mailboxID = b.MailboxID and b.facilityID =@facilityID and b.InmateID= @InmateID  ;
		 insert  @InmateAct  (RecordID , InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, CommStatus,RecordOpt ) 
			select RecordName, b.InmateID, RecordDate, 3, stationID, '', isnull(duration,0), 1,RecordOpt   from tblVisitcalls a with(nolock) , tblInmate b with(nolock), tblVisitPhone c with(nolock)
			where a.FacilityID = b.facilityID and b.facilityID = c.FacilityID and a.PIN = b.PIN and a.ExtID = c.ExtID and a.facilityID =@facilityID and b.InmateID= @InmateID  ; 	

	 end
 end
if(select count(*) from @InmateAct ) >0
 begin
	Update @inmateAct set InmateName = isnull(firstName, ' ') +' ' + isnull(lastName, ' ') 
		from tblInmate a with(nolock), @inmateAct b where a.InmateID = b.inmateID and a.facilityID = @facilityID and InmateName is null;
    Update @inmateAct set ContactName = firstName +' ' + lastName 
		from tblPrepaid a with(nolock), @inmateAct b where a.PhoneNo= b.ContactPhone and a.LastName <>'For Prepaid' and a.FirstName <> 'ICON Transfer';
    Update @inmateAct set ContactName = firstName +' ' + lastName 
		from tblFreePhones a with(nolock), @inmateAct b where a.PhoneNo= b.ContactPhone and b.ContactName is null; 
    Update @inmateAct  set InmateID='0', InmateName=''  where InmateID='' or InmateID is null or InmateID='0';
	Update  @inmateAct   set ActivityStatus = 'Completed' from  @inmateAct   where CommunityType =1 and CommStatus=0 ;
	Update  @inmateAct   set ActivityStatus =b.Descript from  @inmateAct a, tblErrorType b  where CommunityType =1 and a.CommStatus= b.ErrorType and  ActivityStatus is null;
	Update  @inmateAct   set ActivityStatus = Descript from tblVisitStatus a,  @inmateAct  b where a.StatusID= b.CommStatus and CommunityType =2;
	Update  @inmateAct   set ActivityStatus = Descript from tblMessageStatus a,  @inmateAct  b where a.MessStatus = b.CommStatus and CommunityType >3;
	Update  @inmateAct   set ActivityStatus ='Completed' where CommunityType =3;
	Update @inmateAct  set PhoneType =2  from TecoData.dbo.tblEndUser a, @inmateAct b where a.billToNo = b.ContactPhone and a.replyCode='399';
	Update @inmateAct  set PhoneType =1  from TecoData.dbo.tblEndUser a, @inmateAct b where a.billToNo = b.ContactPhone and a.replyCode='050';
 end

-- select * from @InmateAct
Select RecordID , InmateID ,isnull(InmateName,'') as InmateName, ActivityDate, b.Description as ActivityType, isnull( StationID,'')  StationID, ContactPhone , isnull( ContactName, '')  ContactName ,  (CASE a.CommunityType when 5 then 'NA' else  [dbo].[fn_ConvertSecToMin] ( Duration) end)  Duration, 
			ActivityStatus,c.Descript Phonetype, RecordOpt
	from  @InmateAct a, tblCommunicationType b, tblPhoneTypes c
	where a.CommunityType = b.commID  and a.PhoneType = c.PhoneType
	group by  InmateID ,InmateName, ActivityDate,  StationID, ContactPhone ,  ContactName ,  Duration, CommStatus ,RecordID, b.Description,ActivityStatus,  a.CommunityType,c.Descript, RecordOpt
	Order by  ActivityDate, InmateID 	 Desc ;
     
    
END




