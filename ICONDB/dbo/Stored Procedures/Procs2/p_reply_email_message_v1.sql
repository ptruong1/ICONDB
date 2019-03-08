CREATE PROCEDURE [dbo].[p_reply_email_message_v1]  -- Family send Email to Inmate Email Box
@MailBoxID bigint,
@MessageID	bigint,
@SenderMailBoxID bigint,
@MessageName	varchar(50),
@Message		Nvarchar(2500),
@CCEmails	varchar(200),
@AccountNo	varchar(12),
@InmateID	varchar(12)
AS
Begin
	Declare  @folderDate char(8), @FFMailBoxID int, @ReplyMessageID bigint, @EmailApvReq bit,@MessageStatus tinyint,@facilityID int, @MonOpt varchar(1);
	
	SET @ReplyMessageID =0;
	SET @messageName = 'Re:'+ @messageName;
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @EmailApvReq =0;
	Select @facilityID = facilityID from tblMailbox with(nolock) where MailboxID = @SenderMailBoxID;
	declare @timeZone smallint, @LocalTime datetime;
	SET @timeZone =0;
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	SET @MonOpt ='Y';
	SELECT @EmailApvReq =isnull(EmailApvReq,0) , @MonOpt = isnull( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	if(@EmailApvReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	update tblMailboxDetailF  set IsReply = 1 where MailBoxID = @MailBoxID and MessageID= @MessageID
	SELECT @ReplyMessageID = messageID from  tblMailboxDetail where MailBoxID =  @SenderMailBoxID   Order by   messageID ASC;
	SET @ReplyMessageID =@ReplyMessageID +1;
	declare @charge smallmoney;
	exec [p_get_Message_Charge] @facilityID, 2, @charge output

	INSERT tblMailboxDetail(MailBoxID ,  messageID,  MessengerNo, MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID, CCEmails , IsReply, MessageStatus, Charge, MonitorOpt )
				values(@SenderMailBoxID, @ReplyMessageID, '', @LocalTime,@messageName,1, @Message,2,@MailBoxID,@CCEmails,1,@MessageStatus,@charge ,@MonOpt);


	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge	 where phoneno = @AccountNo;
		Insert tblprepaidPaidlog(FacilityID  ,AccountNo  ,  PaidAmount       ,     PaidType ,PaidDate        ,        InmateID)
							values(@FacilityID,@AccountNo,@Charge,2,getdate(),@InmateID) ;
		return 0;
	 end
	return @@error;
End;
