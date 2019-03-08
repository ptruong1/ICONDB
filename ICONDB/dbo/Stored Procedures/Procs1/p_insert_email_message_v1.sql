CREATE PROCEDURE [dbo].[p_insert_email_message_v1]  -- Family send Email to Inmate Email Box
@AccountNo	varchar(12),
@FacilityID	int,
@InmateID	varchar(12),
@MessageName	varchar(50),
@Message		Nvarchar(4000),
@Charge	smallmoney,
@CCEmails	varchar(200)
AS
Begin
	Declare @MailBoxID int, @messageID int, @folderDate char(8), @FFMailBoxID int, @MessageStatus tinyint, @timezone smallint, @LocalTime datetime,
	        @return_value int, @nextID int, @ID int, @tblMailbox nvarchar(32),@tblMailboxF nvarchar(32),  @EmailApvReq bit , @MonOpt char(1) ;
	SET @MailBoxID =0;
	SET @messageID =0;
	SET  @FFMailBoxID =0;
	SET  @MessageStatus =1;
	--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
	SET @timeZone  =0;
	SET @EmailApvReq =1;
	SET @MonOpt ='Y';
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID ;
	
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	
	select @EmailApvReq = isnull(EmailApvReq,1), @MonOpt =isnull(MonOpt,'Y')  from tblFacilityMessageConfig with(nolock) where facilityID = @FacilityID;
	
	if(@EmailApvReq =0)
		SET @MessageStatus =2;

	if(select count(*) from tblUserprofiles where userID=@AccountNo ) >0
		SET @MessageStatus =2;

	Select @FFMailBoxID = MailBoxID from tblMailboxF where Accountno = @AccountNo ;
	
	If (@FFMailBoxID=0)  -- create new mailbox
	 begin
	    EXEC   @return_value = p_create_nextID 'tblMailboxF', @nextID   OUTPUT
		set           @ID = @nextID ;  
		INSERT tblMailboxF (MailboxID,  FacilityID , AccountNo  ,SetupDate ,   status)   values(@ID,  @facilityID , @AccountNo, @LocalTime,1);

 		SET @FFMailBoxID = @ID;
	 end
	select @MailBoxID =MailBoxID from tblMailbox with(nolock) where facilityID = @FacilityID and InmateID = @InmateID; 
	If (@MailBoxID=0)  -- create new mailbox
	 begin
	     EXEC   @return_value = p_create_nextID 'tblMailbox', @nextID   OUTPUT
         set           @ID = @nextID ;  
		INSERT tblMailbox ( MailboxID, FacilityID , InmateID  ,SetupDate ,   status)   values(@ID,  @facilityID , @InmateID, @LocalTime,1);

 		SET @MailBoxID = @ID;
	 end

	SELECT @messageID = messageID from  tblMailboxDetail where MailBoxID =  @MailBoxID  Order by   messageID ASC;
	SET @messageID = @messageID +1;
	
	if(@CCEmails is null or @CCEmails ='')
		select @CCEmails = email from tblEndusers with(nolock) where UserName = @AccountNo;

	INSERT tblMailboxDetail(MailBoxID ,  messageID,  MessengerNo, MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID, CCEmails, Charge,MessageStatus, MonitorOpt  )
				values(@MailBoxID, @messageID, @AccountNo,@LocalTime,@messageName,1, @Message,2, @FFMailBoxID,@CCEmails,@Charge,@MessageStatus, @MonOpt);


	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge	 where phoneno = @AccountNo;
		Insert tblprepaidPaidlog(FacilityID  ,AccountNo  ,  PaidAmount       ,     PaidType ,PaidDate        ,        InmateID)
							values(@FacilityID,@AccountNo,@Charge,2,getdate(),@InmateID) ;
		return 0;
	 end
	return @@error;
End;

