CREATE PROCEDURE [dbo].[p_insert_video_message_v1]  -- Family send Email to Inmate Email Box
@AccountNo	varchar(12),
@MailBoxID int, -- inmate Mailbox
@FacilityID	int,
@InmateID	varchar(12),
@UserID	varchar(10),
@Charge	smallmoney,
@SessionID int,
@Subject VARCHAR(50)
AS
Begin
	Declare  @messageID int, @folderDate char(8),  @message VARCHAR(50), @InmateMailboxID as int, @SenderMailBoxID int, @VideoMessageAppdReq tinyint,@MessageStatus tinyint, @timezone smallint, @localTime datetime, @MonOpt varchar(1);
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET  @VideoMessageAppdReq =1;
	SET @SenderMailBoxID = CAST (left(@UserID,len(@userID) -1) as int);
	SET @MonOpt ='Y';
	set @message = cast(@MailboxID as varchar(10)) + '_' + cast(@userID as varchar(10)) + '_' + CAST(@SessionID as Varchar(10));
	--select @InmateMailboxID = mailboxID from tblMailbox where facilityID = @FacilityID and InmateID=@InmateID;

	select @VideoMessageAppdReq = isnull(VideoApvReq,0), @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where FacilityID =@facilityID ;
	if( @VideoMessageAppdReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE())

	INSERT tblMailboxDetail(MailBoxID ,  messageID,  MessengerNo, MessageDate , MessageName ,Message   ,  IsNew,  MessageTypeID,SenderMailBoxID, Charge ,MessageStatus, MonitorOpt)
				values(@MailBoxID, @SessionID, @AccountNo,  @LocalTime,@Subject, @message, 1,4,  @SenderMailBoxID,@Charge,@MessageStatus, @MonOpt );

	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge, ModifyDate=getdate()	 where phoneno = @AccountNo;
	 end
	return @@error;
End;
