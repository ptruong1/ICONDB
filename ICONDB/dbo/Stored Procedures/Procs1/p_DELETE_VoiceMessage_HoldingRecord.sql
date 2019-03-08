-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_DELETE_VoiceMessage_HoldingRecord]
(
	@MailBoxId int,
	@MessageId int,
	@Extension varchar(10)
)
AS
	SET NOCOUNT OFF;
delete tblRecordingVoiceMessageTransHolder
			where MailBoxID= @MailBoxId and messageId = @MessageId and extension = @Extension;
begin
	if @Extension = '-Out.wav'
		update tblRecordingVoiveMessages set [status]=2
		, OutStatus = 3
		, processTime=getdate() 
			where  MailBoxID= @MailBoxId and messageId = @MessageId ;
		
	else
		update tblRecordingVoiveMessages set [status]=2
		, InStatus = 3
		, processTime=getdate() 
			where  MailBoxID= @MailBoxId and messageId = @MessageId ;
		
	end
