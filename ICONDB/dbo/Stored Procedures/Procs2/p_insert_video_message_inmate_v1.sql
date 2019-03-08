CREATE PROCEDURE [dbo].[p_insert_video_message_inmate_v1]  -- Email send Video Message
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
	Declare  @messageID int, @folderDate char(8),  @message VARCHAR(50), @InmateMailboxID as int, @SenderMailBoxID int, @MonOpt varchar(1);
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @SenderMailBoxID = CAST (left(@UserID,len(@userID) -1) as int);
	SET @MonOpt  ='Y';
	set @message = cast(@MailboxID as varchar(10)) + '_' + cast(@userID as varchar(10)) + '_' + CAST(@SessionID as Varchar(10));
	--select @InmateMailboxID = mailboxID from tblMailbox where facilityID = @FacilityID and InmateID=@InmateID;
	SELECT  @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	INSERT tblMailboxDetailF(MailBoxID ,  messageID,   MessageDate , MessageName ,Message   ,  IsNew,  MessageTypeID,SenderMailBoxID, Charge ,MessageStatus, MonitorOpt)
				values(@MailBoxID, @SessionID,  getdate(),@Subject, @message, 1,4,  @SenderMailBoxID,@Charge,1, @MonOpt );

	if(@@error= 0) 
	 begin
		Update tblDebit   SET balance = balance-@Charge	 where InmateID = @InmateID and FacilityID =@facilityID;
	 end
	return @@error;
End;
