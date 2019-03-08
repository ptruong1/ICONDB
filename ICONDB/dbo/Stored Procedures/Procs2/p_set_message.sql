CREATE PROCEDURE [dbo].[p_set_message]
@AccountNo	char(10),
@facilityID	int,
@InmateID	varchar(12),
@messageName	varchar(50),
@Charge	numeric(6,4)
AS
Begin
	SET NOCOUNT ON;

	
		Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32) ;

    EXEC   @return_value = p_create_nextID 'tblMailBox', @nextID   OUTPUT;

	Declare @MailBoxID int, @messageID int, @folderDate char(8), @FFMailBoxID int, @VoiceApprovedReq bit, @MessageStatus tinyint, @LocalTime datetime, @timeZone smallint, @MonOpt char(1);
	SET @MailBoxID =0;
	SET @messageID =0;
	SET @MonOpt ='Y';
	SET @folderDate = substring(@messageName, CHARINDEX('_',@messageName,1) +1,8);	
	SET @VoiceApprovedReq =0;
	SET  @timeZone  =0;
	Select @FFMailBoxID = MailBoxID from tblMailboxF with(nolock) where Accountno = @AccountNo ;

	select @VoiceApprovedReq = isnull(VoiceApvReq,0),  @MonOpt =isnull(MonOpt,'Y')  from tblFacilityMessageConfig with(nolock) where FacilityID =@facilityID ;
	if(@VoiceApprovedReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	If (@FFMailBoxID=0)  -- create new mailbox
	 begin
		EXEC   @return_value = p_create_nextID 'tblMailBoxF', @nextID   OUTPUT;
		SET @FFMailBoxID = @nextID; 
		INSERT tblMailboxF ( MailboxID,  FacilityID , AccountNo  ,SetupDate ,   status)   values(@FFMailBoxID ,  @facilityID , @AccountNo, @LocalTime,1);

 		
	 end
	
	select @MailBoxID =MailBoxID from tblMailbox with(nolock) where facilityID = @facilityID and InmateID = @InmateID;
	If (@MailBoxID=0)  -- create new mailbox
	 begin
		EXEC   @return_value = p_create_nextID 'tblMailBox', @nextID   OUTPUT;
		SET @MailBoxID= @nextID;
		INSERT tblMailbox (MailboxID,  FacilityID , InmateID  ,SetupDate ,   status)  values(@MailBoxID,  @facilityID , @InmateID, @LocalTime,1);

	 end

	SELECT @messageID = messageID from  tblMailboxDetail with(nolock) where MailBoxID =  @MailBoxID  Order by   messageID ASC;
	SET @messageID = @messageID +1;

	INSERT tblMailboxDetail(MailBoxID ,  messageID,MessageTypeID,  MessengerNo, MessageDate , MessageName,Message    ,  IsNew, folderDate ,MessageStatus, SenderMailBoxID,Charge , MonitorOpt)
				values(@MailBoxID, @messageID,1, @AccountNo, @LocalTime,@messageName,@messageName,1,@folderDate,@MessageStatus,@FFMailBoxID,@Charge, @MonOpt );


	if(@@error= 0) 
	 begin
		Update tblprepaid   SET balance = balance-@Charge	 where phoneno = @AccountNo;
		Select  1 as Success;
	 end
	else
		Select  0 as Success;
End;
