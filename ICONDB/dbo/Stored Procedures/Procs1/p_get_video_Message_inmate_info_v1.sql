-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_video_Message_inmate_info_v1]
@FacilityID int,
@AccountNo varchar(12), 
@InmateID	varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @RecordingServer as varchar(25), @FMailBoxID int, @SessionID int, @IMailboxID int, @Charge smallmoney, @Duration smallint, @receiveEmail varchar(50) ,
	@return_value int, @nextID int, @ID int, @tblMailbox nvarchar(32),@tblMailboxF nvarchar(32) ;
	SET @SessionID =1;
	SET @FMailBoxID =0;
	SET  @IMailboxID =0;
	SET @Charge =1;
	SET @Duration =1;
	SET @RecordingServer='v1.legacyinmate.com';
	select  @receiveEmail = email from tblEndusers with(nolock) where username=@AccountNo;
	select @charge = Charge from tblMessageRate with(nolock) where FacilityID=@FacilityID;
	select @RecordingServer =ChatServerIP  from tblVisitPhoneServer with(nolock) where  FacilityID = @FacilityID;
	select @Duration = isnull(videoLength,60)/60 from tblFacilityMessageConfig with(nolock) where  FacilityID = @FacilityID;
	Select  @IMailboxID = MailboxID from tblMailbox with(nolock) where facilityID = @FacilityID and InmateID=@InmateID ;
	If (@IMailBoxID=0)  -- create new mailbox
	 begin
		EXEC   @return_value = p_create_nextID 'tblMailbox', @nextID   OUTPUT
            set           @ID = @nextID ;  
		INSERT tblMailbox (MailBoxID, FacilityID , InmateID ,SetupDate ,   status)   values(@ID,  @facilityID , @InmateID, GETDATE(),1);
 		SET @IMailBoxID = @ID;
	 end

	select @FMailBoxID=MailboxID from tblMailboxF where FacilityID = @FacilityID and AccountNo =@AccountNo;
	If (@FMailBoxID=0)  -- create new mailbox
	 begin 
	 EXEC   @return_value = p_create_nextID 'tblMailboxF', @nextID   OUTPUT
		set           @ID = @nextID ;
		INSERT tblMailboxF (MailBoxID, FacilityID , AccountNo ,SetupDate ,   status)   values(@ID,  @facilityID , @AccountNo, GETDATE(),1);
 		SET @FMailBoxID = @ID;
	 end
	 select top 1 @SessionID = MessageID + 1 from tblMailboxDetailF with(nolock) where mailboxID = @FMailBoxID order by MessageID desc; 

	 Select  @FMailboxID as MailBoxID, (CAST(@IMailBoxID as varchar(10)) + 'V') as UserID,@SessionID as SessionID,   @Charge as Charge , @Duration as Duration,@RecordingServer as RecordingServer , @receiveEmail as  ReceiveEmail ;
	
	
END

