
CREATE PROCEDURE [dbo].[p_Insert_VoiceMessage_TransMatch]
@MailBoxID	bigint,
@MessageId	bigint,
@WordsMatch	varchar(500),
@CallerText varchar(MAX),
@CalleeText varchar(MAX),
@TransCode int  -- = 0 caller, = 1 callee

As
SET NOCOUNT ON;

Begin
	Begin
	if(select count(*) from tblRecordingVoiceMessageTranscripted where MailBoxID =@MailBoxId and MessageID =@MessageId) =0
		Insert tblRecordingVoiceMessageTranscripted (MailBoxId, MessageId, WordsMatch,CalleeText,CallerText) values(@MailBoxId, @MessageId, @WordsMatch,@CalleeText,@CallerText);  -- match files
	else
	
	if @TransCode = 0
		update tblRecordingVoiceMessageTranscripted 
		set
		 WordsMatch = @WordsMatch + ' ' + (select wordsMatch from tblRecordingVoiceMessageTranscripted where MailBoxID =@MailBoxId and MessageID =@MessageId)
		,CallerText=  @CallerText
		
		 where MailBoxID =@MailBoxId and MessageID =@MessageId;
	else
		 update tblRecordingVoiceMessageTranscripted 
		set
		  WordsMatch = @WordsMatch + ' ' + (select wordsMatch from leg_Icon.dbo.tblRecordingTransMatch where MailBoxID =@MailBoxId and MessageID =@MessageId)
		, CalleeText= @CalleeText
		
		 where MailBoxID =@MailBoxId and MessageID =@MessageId;
	end
	begin
	if @TransCode = 0
		update tblRecordingVoiveMessages set [status]=2
		, OutStatus = 2
		, processTime=getdate() 
			where MailBoxID =@MailBoxId and MessageID =@MessageId ;
		
	else
		update tblRecordingVoiveMessages set [status]=2
		, InStatus = 2
		, processTime=getdate() 
			where MailBoxID =@MailBoxId and MessageID =@MessageId ;
		
	end
	begin
	if @TransCode = 0
		--update leg_Icon.dbo.tblRecordingListTransHolder set [Mainstatus]=2
		--, OutStatus = 2
		delete tblRecordingVoiceMessageTransHolder
			where MailBoxID =@MailBoxId and MessageID =@MessageId and extension = '-Out.wav'; 
	else
		--update leg_Icon.dbo.tblRecordingListTransHolder set [Mainstatus]=2
		--, Instatus = 2
		delete tblRecordingVoiceMessageTransHolder
			where MailBoxID =@MailBoxId and MessageID =@MessageId and extension = '-In.wav';
	end
 End
 
 
 
 

