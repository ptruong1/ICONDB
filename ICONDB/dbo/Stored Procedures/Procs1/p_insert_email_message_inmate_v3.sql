CREATE PROCEDURE [dbo].[p_insert_email_message_inmate_v3]  -- Inmate send Email to Family
@FacilityID	int,
@InmateID	varchar(12),
@FamilyPhone	varchar(12),
@MessageName	varchar(50),
@Message		Nvarchar(4000),
@Charge	smallmoney,
@Email	varchar(70),
@paymentType tinyint,  -- 1 :Inmate Debit   ; 2 Family Prepaid 
@DeviceName  varchar(20)
AS

Begin
    
	Declare @MailBoxID int, @messageID int, @folderDate char(8), @FFMailBoxID int, @Emnail varchar(40),@Balance numeric(6,2),@EmailApvReq bit,
	@MessageStatus tinyint, @return_value int, @nextID int, @ID int, @tblMailbox nvarchar(32),@tblMailboxF nvarchar(32), @MonOpt char(1);
	declare @timezone smallint, @localTime datetime;
	SET @MailBoxID =0;
	SET @messageID =0;
	SET  @FFMailBoxID =0;
	SET @Balance =0;
	SET @EmailApvReq =1;
	SET @timeZone =0;
	SET @MonOpt ='Y';
	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	
	SELECT @EmailApvReq =isnull(EmailApvReq,1), @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	if(@EmailApvReq =0)
		SET @MessageStatus =2;
	else
		SET @MessageStatus =1;
	if(@paymentType =1)
		select @Balance = balance from tblDebit   	where InmateID  =@InmateID and FacilityID = @FacilityID and status= 1;
	else
		select @Balance = balance from tblprepaid   	where phoneno  =@FamilyPhone and FacilityID = @FacilityID and status= 1;
	if(@Balance > @charge)
	 Begin
	
		--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
		Select @FFMailBoxID = MailBoxID from tblMailboxF where Accountno = @FamilyPhone ;
		
		If (@FFMailBoxID=0)  -- create new mailbox
		 begin
		    EXEC   @return_value = p_create_nextID 'tblMailboxF', @nextID   OUTPUT
             set           @ID = @nextID ; 
			INSERT tblMailboxF (MailboxID,  FacilityID , AccountNo  ,SetupDate ,   status)   values(@ID,  @facilityID , @FamilyPhone , @LocalTime,1);

 			SET @FFMailBoxID = @ID;
		 end
		select @MailBoxID =MailBoxID from tblMailbox where facilityID = @FacilityID and InmateID = @InmateID; 
		If (@MailBoxID=0)  -- create new mailbox
		 begin
		    EXEC   @return_value = p_create_nextID 'tblMailbox', @nextID   OUTPUT
            set           @ID = @nextID ;  
			INSERT tblMailbox (MailboxID,  FacilityID , InmateID  ,SetupDate ,   status)   values(@ID,  @facilityID , @InmateID, @LocalTime,1);

 			SET @MailBoxID = @ID;
		 end

		SELECT @messageID = messageID from  tblMailboxDetailF where MailBoxID =  @FFMailBoxID  Order by   messageID ASC;
		SET @messageID = @messageID +1;

		INSERT tblMailboxDetailF(MailBoxID ,  messageID, MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID ,Email,MessageStatus,Charge, MonitorOpt, DeviceName)
					values(@FFMailBoxID, @messageID,  @LocalTime,@messageName,1, @Message,2, @MailBoxID,@Email,@MessageStatus,@Charge,  @MonOpt, @DeviceName );
		

		if(@@error= 0) 
		 begin
			if(@paymentType =1)
				Update tblDebit   SET balance = balance-@Charge	 where InmateID  =@InmateID and FacilityID = @FacilityID ;
			else
				Update tblPrepaid   SET balance = balance-@Charge	 where phoneno =@FamilyPhone and FacilityID = @FacilityID ;
			return 0;
		 end
		return @@error;
	 end
	else
	 begin
		return -1;
	 end
End;

--Begin
    
--	Declare @MailBoxID int, @messageID int, @folderDate char(8), @FFMailBoxID int, @Emnail varchar(40),@Balance numeric(6,2),@EmailApvReq bit,@MessageStatus tinyint;
--	declare @timezone smallint, @localTime datetime;
--	SET @MailBoxID =0;
--	SET @messageID =0;
--	SET  @FFMailBoxID =0;
--	SET @Balance =0;
--	SET @EmailApvReq =0;
--	SET @timeZone =0;
--	Select @timeZone = timeZone from tblfacility with(nolock) where FacilityID = @facilityID  ;
--	SET @LocalTime = DATEADD (HOUR, @timeZone , GETDATE());
	
--	SELECT @EmailApvReq =isnull(EmailApvReq,0) from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
--	if(@EmailApvReq =0)
--		SET @MessageStatus =2;
--	else
--		SET @MessageStatus =1;
--	if(@paymentType =1)
--		select @Balance = balance from tblDebit   	where InmateID  =@InmateID and FacilityID = @FacilityID and status= 1;
--	else
--		select @Balance = balance from tblprepaid   	where phoneno  =@FamilyPhone and FacilityID = @FacilityID and status= 1;
--	if(@Balance > @charge)
--	 Begin
	
--		--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
--		Select @FFMailBoxID = MailBoxID from tblMailboxF where Accountno = @FamilyPhone ;
		
--		If (@FFMailBoxID=0)  -- create new mailbox
--		 begin
--			INSERT tblMailboxF (  FacilityID , AccountNo  ,SetupDate ,   status)   values(  @facilityID , @FamilyPhone , @LocalTime,1);

-- 			SET @FFMailBoxID = SCOPE_IDENTITY();
--		 end
--		select @MailBoxID =MailBoxID from tblMailbox where facilityID = @FacilityID and InmateID = @InmateID; 
--		If (@MailBoxID=0)  -- create new mailbox
--		 begin
--			INSERT tblMailbox (  FacilityID , InmateID  ,SetupDate ,   status)   values(  @facilityID , @InmateID, @LocalTime,1);

-- 			SET @MailBoxID = SCOPE_IDENTITY();
--		 end

--		SELECT @messageID = messageID from  tblMailboxDetailF where MailBoxID =  @FFMailBoxID  Order by   messageID ASC;
--		SET @messageID = @messageID +1;

--		INSERT tblMailboxDetailF(MailBoxID ,  messageID, MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID ,Email,MessageStatus,Charge)
--					values(@FFMailBoxID, @messageID,  @LocalTime,@messageName,1, @Message,2, @MailBoxID,@Email,@MessageStatus,@Charge);
		

--		if(@@error= 0) 
--		 begin
--			if(@paymentType =1)
--				Update tblDebit   SET balance = balance-@Charge	 where InmateID  =@InmateID and FacilityID = @FacilityID ;
--			else
--				Update tblPrepaid   SET balance = balance-@Charge	 where phoneno =@FamilyPhone and FacilityID = @FacilityID ;
--			return 0;
--		 end
--		return @@error;
--	 end
--	else
--	 begin
--		return -1;
--	 end
--End;

