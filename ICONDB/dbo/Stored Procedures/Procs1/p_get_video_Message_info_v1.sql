-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_video_Message_info_v1]
@FacilityID int,
@AccountNo varchar(12),
@InmateID	varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @RecordingServer as varchar(25), @MailBoxID int, @SessionID int, @FMailboxID int, @Charge smallmoney, @Duration smallint ;
	SET @SessionID =1;
	SET @MailBoxID =0;
	SET  @FMailboxID =0;
	SET @Charge =1;
	SET @Duration =1;
	SET @RecordingServer='v1.legacyinmate.com';
	select @charge = Charge from tblMessageRate with(nolock) where FacilityID=@FacilityID;
	select @RecordingServer =ChatServerIP  from tblVisitPhoneServer with(nolock) where  FacilityID = @FacilityID;
	select @Duration = videoLength from tblFacilityMessageConfig with(nolock) where  FacilityID = @FacilityID;
	Select  @FMailboxID = MailboxID from tblMailboxF with(nolock) where facilityID = @FacilityID and AccountNo = @AccountNo ;
	If (@FMailBoxID=0)  -- create new mailbox
	 begin
		INSERT tblMailboxF ( FacilityID , AccountNo ,SetupDate ,   status)   values(  @facilityID , @AccountNo, GETDATE(),1);
 		SET @FMailBoxID = SCOPE_IDENTITY();
	 end

	select @MailBoxID=MailboxID from tblMailbox where FacilityID = @FacilityID and InmateID =@InmateID ;
	If (@MailBoxID=0)  -- create new mailbox
	 begin
		INSERT tblMailbox (  FacilityID , InmateID ,SetupDate ,   status)   values(  @facilityID , @InmateID, GETDATE(),1);
 		SET @MailBoxID = SCOPE_IDENTITY();
	 end
	 select top 1 @SessionID = MessageID + 1 from tblMailboxDetail with(nolock) where mailboxID = @MailBoxID order by MessageID desc; 

	 Select  @MailboxID as MailBoxID, (CAST(@FMailBoxID as varchar(10)) + 'I') as UserID,@SessionID as SessionID,   @Charge as Charge , @Duration as Duration,@RecordingServer as RecordingServer ;
	

END

