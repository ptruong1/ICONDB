CREATE PROCEDURE [dbo].[p_insert_email_message]  -- Family send Email to Inmate Email Box
@AccountNo	varchar(12),
@FacilityID	int,
@InmateID	varchar(12),
@MessageName	varchar(35),
@Message		varchar(4000),
@Charge	smallmoney
AS
Begin
	Declare @MailBoxID int, @messageID int, @folderDate char(8), @FFMailBoxID int, @EmailApvReq bit,@MessageStatus tinyint,@timeZone smallint,@LocalTime datetime, @MonOpt char(1),
	@return_value int, @nextID int, @ID int, @tblMailbox nvarchar(32),@tblMailboxF nvarchar(32) ;
	SET @MailBoxID =0;
	SET @messageID =0;
	SET  @FFMailBoxID =0;
	SET @EmailApvReq =0;
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @timeZone =0;
	SET @MonOpt = 'Y';
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	
	SELECT @EmailApvReq =isnull(EmailApvReq,1), @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	if(@EmailApvReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	 
	Select @FFMailBoxID = MailBoxID from tblMailboxF where Accountno = @AccountNo ;
	
	If (@FFMailBoxID=0)  -- create new mailbox
	 begin
	 EXEC   @return_value = p_create_nextID 'tblMailboxF', @nextID   OUTPUT
		set           @ID = @nextID ; 
		INSERT tblMailboxF (MailBoxID, FacilityID , AccountNo  ,SetupDate ,   status)   values(@ID, @facilityID , @AccountNo, @LocalTime,1);

 		SET @FFMailBoxID = @ID;
	 end
	select @MailBoxID =MailBoxID from tblMailbox where facilityID = @FacilityID and InmateID = @InmateID; 
	If (@MailBoxID=0)  -- create new mailbox
	 begin
		EXEC   @return_value = p_create_nextID 'tblMailbox', @nextID   OUTPUT
         set           @ID = @nextID ;  
		INSERT tblMailbox ( MailboxID, FacilityID , InmateID  ,SetupDate ,   status)   values(@ID,  @facilityID , @InmateID, @LocalTime,1);

 		SET @MailBoxID = @ID;
	 end

	SELECT @messageID = messageID from  tblMailboxDetail where MailBoxID =  @MailBoxID  Order by   messageID ASC;
	SET @messageID = @messageID +1;

	INSERT tblMailboxDetail(MailBoxID ,  messageID,  MessengerNo, MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID,MessageStatus,Charge, MonitorOpt )
				values(@MailBoxID, @messageID, @AccountNo,@LocalTime,@messageName,1, @Message,2, @FFMailBoxID,@MessageStatus, @Charge,  @MonOpt);


	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge, ModifyDate =GETDATE()	 where phoneno = @AccountNo;
		return 0;
	 end
	return @@error;
End;

