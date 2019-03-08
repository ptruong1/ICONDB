CREATE PROCEDURE [dbo].[p_insert_video_message_inmate_v2]  -- Email send Video Message
@AccountNo	varchar(12),
@MailBoxID int, -- inmate Mailbox
@FacilityID	int,
@InmateID	varchar(12),
@UserID	varchar(10),
@Charge	smallmoney,
@SessionID int,
@Subject VARCHAR(50),
@PaymentType tinyint -- 1 :Inmate Debit   ; 2 Family Prepaid 

AS
Begin
	Declare  @messageID int, @folderDate char(8),  @message VARCHAR(50), @InmateMailboxID as int, @SenderMailBoxID int,  @VideoMessageAppdReq tinyint, @MessageStatus tinyint, @timeZone smallint, @localTime datetime,  @MonOpt varchar(1);
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @SenderMailBoxID = CAST (left(@UserID,len(@userID) -1) as int);
	set @message = cast(@MailboxID as varchar(10)) + '_' + cast(@userID as varchar(10)) + '_' + CAST(@SessionID as Varchar(10));
	--select @InmateMailboxID = mailboxID from tblMailbox where facilityID = @FacilityID and InmateID=@InmateID;

	select @VideoMessageAppdReq = isnull(VideoApvReq,0), @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where FacilityID =@facilityID ;
	if( @VideoMessageAppdReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE())

	INSERT tblMailboxDetailF(MailBoxID ,  messageID,   MessageDate , MessageName ,Message   ,  IsNew,  MessageTypeID,SenderMailBoxID, Charge ,MessageStatus, MonitorOpt)
				values(@MailBoxID, @SessionID,  @LocalTime,@Subject, @message, 1,4,  @SenderMailBoxID,@Charge,@MessageStatus, @MonOpt );

	if(@@error= 0) 
	 begin
			if(@paymentType =1)
				Update tblDebit   SET balance = balance-@Charge	, modifyDate = getdate() where InmateID  =@InmateID and FacilityID = @FacilityID ;
			else
				Update tblPrepaid   SET balance = balance-@Charge, modifyDate = getdate()	 where phoneno =@AccountNo and FacilityID = @FacilityID ;
			
     end
	return @@error;
End;
