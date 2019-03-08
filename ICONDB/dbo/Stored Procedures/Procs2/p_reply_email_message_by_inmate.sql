CREATE PROCEDURE [dbo].[p_reply_email_message_by_inmate]  -- Inmate reply Email to Family Email Box
@MailBoxID bigint,
@MessageID	bigint,
@SenderMailBoxID bigint,
@MessageName	varchar(50),
@Message		Nvarchar(2500),
@Email	varchar (70)
AS
Begin
	Declare  @folderDate char(8), @FFMailBoxID int, @ReplyMessageID bigint,@facilityID int,@MessageStatus tinyint,@EmailApvReq bit , @AccountNo varchar(12), @MonOpt varchar(1) ;
	declare @timeZone smallint, @LocalTime datetime;
	SET @ReplyMessageID =0;
	SET @messageName = 'Re:'+ @messageName;
	SET @EmailApvReq =0;
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @MonOpt ='Y';
	SET @timeZone =0;
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	Select @facilityID = facilityID from tblMailbox with(nolock) where MailboxID =@MailBoxID;
	SELECT @EmailApvReq =isnull(EmailApvReq,0),@MonOpt = ISNULL( MonOpt,'Y')  from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	if(@EmailApvReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	
	update tblMailboxDetail  set IsReply = 1 where MailBoxID = @MailBoxID and MessageID= @MessageID
	SELECT @ReplyMessageID = messageID from  tblMailboxDetailF where MailBoxID =  @SenderMailBoxID   Order by   messageID ASC;
	SET @ReplyMessageID =@ReplyMessageID +1;
	SET  @Email ='';
	Select @accountno = accountNo from tblMailboxF with(nolock) where MailBoxID = @SenderMailBoxID;
	Select @Email = Email from tblEndusers (nolock) where username =@accountno ;

	INSERT tblMailboxDetailF(MailBoxID ,  messageID,   MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID, Email,IsReply,MessageStatus,Charge, MonitorOpt )
				values(@SenderMailBoxID, @ReplyMessageID, @LocalTime,@messageName,1, @Message,2,@MailBoxID,@Email,1,@MessageStatus,0, @MonOpt);
	return @@error;
End;
