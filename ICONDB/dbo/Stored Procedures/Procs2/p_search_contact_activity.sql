-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_search_contact_activity]
@ContactPhone varchar(15),
@facilityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
Declare  @ContactAct table (RecordID varchar(34),FacilityID int, InmateID varchar(12),InmateName varchar(50),  ActivityDate datetime, CommunityType tinyint, StationID varchar(25), ContactPhone varchar(18), ContactName varchar(50), Duration smallint, RecordOpt varchar(1)) ;
	
insert   @ContactAct  (RecordID ,FacilityID, InmateID , ActivityDate, CommunityType, StationID , ContactPhone , Duration, RecordOpt ) 
	select RecordID,FacilityID, InmateID, RecordDate, 1, fromNo,tono, Duration, (Case RecordFile when 'NA' then 'N' Else 'Y' end) from tblcallsbilled with(nolock) where  tono = @ContactPhone ;
  
insert   @ContactAct  (RecordID ,facilityID, InmateID ,InmateName, ActivityDate, CommunityType,  StationID , ContactPhone , Duration, RecordOpt ) 
	select ApmNo,FacilityID,  InmateID,InmateName,  ApmDate+ apmtime , 2, StationID, EnduserID, isnull(visitDuration,0), RecordOpt from tblVisitEnduserSchedule with(nolock)  where enduserID =  @ContactPhone ;
	
insert   @ContactAct (RecordID ,FacilityID, InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, RecordOpt ) 
	select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end),b.FacilityID,c.InmateID  ,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',c.AccountNo,60,'Y'
		from tblMailBoxDetailf a with(nolock)  , tblMailboxF b with(nolock) , tblMailbox c  with(nolock)
		 where a.mailboxID = b.MailboxID and a.SenderMailBoxID = c.MailboxID and b.AccountNo = @ContactPhone;


insert   @ContactAct (RecordID ,FacilityID, InmateID ,ActivityDate, CommunityType,  StationID , ContactPhone , Duration, RecordOpt ) 
	select  (CASE MessageTypeID when 5 then [Message] Else cast(a.MailBoxID as varchar(10)) +'-' + CAST(a.MessageID as varchar(7)) end),b.FacilityID,b.InmateID  ,MessageDate,  (CASE MessageTypeID when 1 then 6 when 2 then 5 when 4 then 4 when 5 then 7 end), '',MessengerNo,60,'Y'
		from tblMailBoxDetail a with(nolock)  , tblMailbox b, tblMailboxF c with(nolock) 
		 where a.mailboxID = b.MailboxID and a.SenderMailBoxID = c.MailboxID and c.AccountNo = @ContactPhone;
		
	    
if(select count(*) from  @ContactAct ) >0
 begin
	Update  @ContactAct set InmateName = firstName +' ' + lastName 
		from tblInmate a with(nolock),  @ContactAct b where a.InmateID = b.inmateID and a.facilityID = @facilityID and InmateName is null;
    Update  @ContactAct set InmateName = firstName +' ' + lastName 
		from tblInmate a with(nolock),  @ContactAct b where a.InmateID = b.inmateID and a.facilityID = b.FacilityID and InmateName is null;
    Update @ContactAct set ContactName = firstName +' ' + lastName 
		from tblPrepaid a with(nolock), @ContactAct b where a.PhoneNo= b.ContactPhone and a.LastName <>'For Prepaid' and a.FirstName <> 'ICON Transfer';
    Update @ContactAct set ContactName = firstName +' ' + lastName 
		from tblFreePhones a with(nolock), @ContactAct b where a.PhoneNo= b.ContactPhone and b.ContactName is null; 
    Update @ContactAct set ContactName = firstName +' ' + lastName 
		from TecoData.dbo.tblCLECEndUser a with(nolock), @ContactAct b where a.BillToNo= b.ContactPhone and b.ContactName is null; 

 end

Select a.FacilityID, Location, RecordID , InmateID ,InmateName, ActivityDate, Description as ActivityType, isnull( StationID,'')  StationID, a.ContactPhone ,  a.ContactName ,  (CASE b.CommID when 5 then 'NA' else  [dbo].[fn_ConvertSecToMin] ( Duration) end)  Duration, 
			 a.RecordOpt
	from  @ContactAct a, tblCommunicationType b, tblfacility c  where a.FacilityID = c.FacilityID and a.CommunityType = b.commID
	Order by ActivityDate ;
     
    
END



