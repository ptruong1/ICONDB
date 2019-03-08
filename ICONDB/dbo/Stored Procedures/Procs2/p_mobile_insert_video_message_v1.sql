CREATE PROCEDURE [dbo].[p_mobile_insert_video_message_v1]  -- Family send video message to Inmate video box
@AccountNo	varchar(12),
@FacilityID	int,
@InmateID	varchar(12),
@Charge	smallmoney,
@Subject VARCHAR(50),
@DeviceName	 varchar(20)
AS
Begin
	Declare  @messageID int,  @folderDate char(8),  @message VARCHAR(50), @InmateMailboxID as int, @FFMailBoxID int, @VideoMessageAppdReq tinyint,@MessageStatus tinyint, @timezone smallint, @localTime datetime, @MonOpt varchar(1);
	Declare @MailBoxID int, @return_value int, @nextID int, @ID int, @tblMailbox nvarchar(32),@tblMailboxF nvarchar(32) ;
	
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET  @VideoMessageAppdReq =1;
	Select @FFMailBoxID = mailboxID from tblMailboxF with(nolock) where facilityID = @FacilityID and accountNo = @AccountNo;
	
	--select @InmateMailboxID = mailboxID from tblMailbox with(nolock) where  facilityID = @FacilityID and InmateID=@InmateID;

	If (@FFMailBoxID=0)  -- create new Family mailbox
	 begin
	 	   EXEC   @return_value = p_create_nextID 'tblMailboxF', @nextID   OUTPUT
         set           @ID = @nextID ; 
		 
		INSERT tblMailboxF (MailBoxID, FacilityID, AccountNo  ,SetupDate ,   status)   values(@ID, @facilityID , @AccountNo, @LocalTime,1);

 		SET @FFMailBoxID = @ID;
	 end
	select @MailBoxID =MailBoxID from tblMailbox with(nolock) where facilityID = @FacilityID and InmateID = @InmateID; 
	If (@MailBoxID=0)  -- create new Inmate mailbox
	 begin
	 EXEC   @return_value = p_create_nextID 'tblMailbox', @nextID   OUTPUT
        set           @ID = @nextID ;  
		INSERT tblMailbox (MailBoxID,  FacilityID , InmateID  ,SetupDate ,   status)   values(@ID,  @facilityID , @InmateID, @LocalTime,1);

 		SET @MailBoxID = @ID;
		SET @messageID =1;
	 end
    else 
	 begin
		select  @messageID = MessageID from tblMailboxDetail with(nolock) where MailboxID =  @MailBoxID order by MessageID;
		SET  @messageID =  @messageID +1;
	 end
	
	set @message = cast(@MailboxID as varchar(10)) + '_I_' + CAST( @messageID  as Varchar(10)) ;
	--SET @message = @message + '_'+ convert(varchar(12), getdate(), 12) + REPLACE( convert(varchar(12), getdate(), 108),':','') ;
	select @VideoMessageAppdReq = isnull(VideoApvReq,0),  @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where FacilityID =@facilityID ;
	-- For temp
	if( @VideoMessageAppdReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE())
	-- set video status =2
	INSERT tblMailboxDetail(MailBoxID ,  messageID,  MessengerNo, MessageDate , MessageName ,Message   ,  IsNew,  MessageTypeID,SenderMailBoxID, Charge ,MessageStatus, videostatus, MonitorOpt, DeviceName)
				values(@MailBoxID, @messageID, @AccountNo,  @LocalTime,@Subject, @Subject, 1,4,  @FFMailBoxID,@Charge,@MessageStatus,2, @MonOpt, @DeviceName);

	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge, ModifyDate=getdate()	 where phoneno = @AccountNo;
	 end
	if @@error = 0
		Select 1 as SendSuccess, @MailBoxID as MailBoxID, @message  as MessageFileName;
	else 
		Select 0 as SendSuccess ,@MailBoxID as MailBoxID,  @message  as MessageFileName;
End;

