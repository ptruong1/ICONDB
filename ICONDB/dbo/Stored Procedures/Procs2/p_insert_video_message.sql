CREATE PROCEDURE [dbo].[p_insert_video_message]  -- Family send Email to Inmate Email Box
@AccountNo	varchar(12),
@MailBoxID int, -- inmate Mailbox
@FacilityID	int,
@InmateID	varchar(12),
@UserID	varchar(10),
@Charge	smallmoney,
@SessionID int
AS
Begin
	Declare  @messageID int, @folderDate char(8),  @messageName VARCHAR(50), @InmateMailboxID as int, @SenderMailBoxID int, @MonOpt varchar(1), @EmailApvReq bit;
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @SenderMailBoxID = CAST (left(@UserID,len(@userID) -1) as int);
	set @messageName = cast(@MailboxID as varchar(10)) + '_' + cast(@userID as varchar(10)) + '_' + CAST(@SessionID as Varchar(10));
	SET @MonOpt ='Y';
	--select @InmateMailboxID = mailboxID from tblMailbox where facilityID = @FacilityID and InmateID=@InmateID;
	SELECT @EmailApvReq =isnull(EmailApvReq,1), @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	INSERT tblMailboxDetail(MailBoxID ,  messageID,  MessengerNo, MessageDate , MessageName    ,  IsNew,  MessageTypeID,SenderMailBoxID, Charge ,MessageStatus, MonitorOpt)
				values(@MailBoxID, @SessionID, @AccountNo, getdate(),@messageName,1,4,  @SenderMailBoxID,@Charge,1, @MonOpt);

	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge	 where phoneno = @AccountNo;
	 end
	return @@error;
End;
