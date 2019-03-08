CREATE PROCEDURE [dbo].[p_insert_email_message_inmate]  -- Inmate send Email to Family
@FacilityID	int,
@InmateID	varchar(12),
@FamilyPhone	varchar(12),
@MessageName	varchar(35),
@Message		varchar(4000),
@Charge	smallmoney
AS

Begin
    
	Declare @MailBoxID int, @messageID int, @folderDate char(8), @FFMailBoxID int, @Emnail varchar(40),@Balance numeric(6,2), @MonOpt varchar(1), @EmailApvReq bit;
	SET @MailBoxID =0;
	SET @messageID =0;
	SET  @FFMailBoxID =0;
	SET @Balance =0;
	SET @MonOpt ='Y';
	SET  @EmailApvReq =0; 
	select @Balance = balance from tblDebit   	where InmateID  =@InmateID and FacilityID = @FacilityID;
	SELECT @EmailApvReq =isnull(EmailApvReq,1), @MonOpt = ISNULL( MonOpt,'Y') from tblFacilityMessageConfig with(nolock) where facilityID =@FacilityID ;
	if(@Balance > 0)
	 Begin
	
		--SET @folderDate = LEFT(RIGHT(@messageName,19),8) ;
		Select @FFMailBoxID = MailBoxID from tblMailboxF where Accountno = @FamilyPhone ;
		
		If (@FFMailBoxID=0)  -- create new mailbox
		 begin
			INSERT tblMailboxF (  FacilityID , AccountNo  ,SetupDate ,   status)   values(  @facilityID , @FamilyPhone , GETDATE(),1);

 			SET @FFMailBoxID = SCOPE_IDENTITY();
		 end
		select @MailBoxID =MailBoxID from tblMailbox where facilityID = @FacilityID and InmateID = @InmateID; 
		If (@MailBoxID=0)  -- create new mailbox
		 begin
			INSERT tblMailbox (  FacilityID , InmateID  ,SetupDate ,   status)   values(  @facilityID , @InmateID, GETDATE(),1);

 			SET @MailBoxID = SCOPE_IDENTITY();
		 end

		SELECT @messageID = messageID from  tblMailboxDetailF where MailBoxID =  @MailBoxID  Order by   messageID ASC;
		SET @messageID = @messageID +1;

		INSERT tblMailboxDetailF(MailBoxID ,  messageID, MessageDate , MessageName    ,  IsNew, [message], MessageTypeID,SenderMailBoxID,MonitorOpt )
					values(@MailBoxID, @messageID,  getdate(),@messageName,1, @Message,2, @MailBoxID, @MonOpt);
		

		if(@@error= 0) 
		 begin
			Update tblDebit   SET balance = balance-@Charge	 where InmateID  =@InmateID and FacilityID = @FacilityID ;
			return 0;
		 end
		return @@error;
	 end
	else
	 begin
		return -1;
	 end
End;
