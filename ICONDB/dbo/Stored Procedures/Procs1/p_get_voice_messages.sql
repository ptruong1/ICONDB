-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_voice_messages]
	@facilityID int, 
	@InmateID varchar(12),
	@IsNew tinyint
AS
BEGIN
	SET NOCOUNT ON;
	Declare @VoiceMessage as varchar(2000),@MessageName as varchar(60), @MessageCount int, @MessageDate as datetime, @CallBackPhoneNo varchar(10) , @ReadCount smallint;
	SET @VoiceMessage ='';
	SET @MessageName ='';
	SET @MessageCount = 0;
	SET @ReadCount = 0;
	if(@IsNew =1)
	 begin
		DECLARE data_cur cursor FOR
		select  b.MessageName ,b.messageDate, b.MessengerNo, b.readCount  from tblMailBox a with(nolock) , tblMailboxDetail b with(nolock) 
		where a.MailboxID= b.MailBoxID 
		and a.InmateID = @InmateID 
		and a.FacilityID =@facilityID
		and b.MessageTypeID =1
		and b.IsNew =@IsNew 
		and readcount <3 and  b.MessageStatus =2
		order by MessageDate desc;	
	 end
	else
	 begin
		DECLARE data_cur cursor FOR
		select  b.MessageName ,b.messageDate, b.MessengerNo, b.readCount  from tblMailBox a with(nolock) , tblMailboxDetail b with(nolock) 
		where a.MailboxID= b.MailBoxID 
		and a.InmateID = @InmateID 
		and a.FacilityID =@facilityID
		and b.MessageTypeID =1
		and b.IsNew =@IsNew 
		and datediff(day, MessageDate,getdate()) <10 and readcount <3 and  b.MessageStatus =2
		order by MessageDate desc;	
	 end


	OPEN data_cur  ;
	FETCH NEXT FROM data_cur INTO @MessageName, @MessageDate, @CallBackPhoneNo,  @ReadCount ;
	WHILE @@FETCH_STATUS = 0   
		BEGIN   
			   SET @MessageCount =@MessageCount +1;
			   If( @MessageCount >1)
					SET @VoiceMessage =@VoiceMessage + ',' + @MessageName + '*' + CAST (@MessageDate as varchar(30)) + '*' + isnull(@CallBackPhoneNo,'') + '*' + CAST( isnull(@ReadCount,0) as varchar(6));
			   else
					SET @VoiceMessage = @MessageName + '*' + CAST( @MessageDate as varchar(30))  + '*' + isnull(@CallBackPhoneNo,'') + '*' + CAST( isnull(@ReadCount,0) as varchar(6));
			   
			   FETCH NEXT FROM data_cur INTO @MessageName,@MessageDate,@CallBackPhoneNo, @ReadCount  ;
		END   
	CLOSE data_cur   ;
	DEALLOCATE data_cur;
	
	SELECT @MessageCount as MessageCount, @VoiceMessage as  VoiceMessage, '3_7' as MessageArchived ;
	
END

