
Create PROCEDURE [dbo].[p_Insert_TransMatch_851_Test]
@RecordID	bigint,
@WordsMatch	varchar(500),
@CallerText varchar(MAX),
@CalleeText varchar(MAX),
@TransCode int  -- = 0 caller, = 1 callee

As
SET NOCOUNT ON;

Begin
	Begin
	if(select count(*) from dbo.tblRecordingTransMatch  where RecordID =@RecordID) =0
		Insert dbo.tblRecordingTransMatch( RecordID, WordsMatch,CalleeText,CallerText) values(@RecordID,@WordsMatch,@CalleeText,@CallerText);  -- match files
	else
	
	if @TransCode = 0
		update dbo.tblRecordingTransMatch  
		set
		 WordsMatch = @WordsMatch + ' ' + (select wordsMatch from dbo.tblRecordingTransMatch  where RecordID = @RecordID)
		,CallerText=  @CallerText
		
		 where RecordID = @RecordID;
	else
		 update dbo.tblRecordingTransMatch  
		set
		  WordsMatch = @WordsMatch + ' ' + (select wordsMatch from dbo.tblRecordingTransMatch  where RecordID = @RecordID)
		, CalleeText= @CalleeText
		
		 where RecordID = @RecordID;
	end
	begin
	if @TransCode = 0
		update dbo.tblRecordingListTrans  set [status]=2
		, OutStatus = 2
		, processTime=getdate() 
			where RecordID= @RecordID ;
		
	else
		update dbo.tblRecordingListTrans  set [status]=2
		, InStatus = 2
		, processTime=getdate() 
			where RecordID= @RecordID ;
		
	end
	begin
	if @TransCode = 0
		--update leg_icon_dev.dbo.tblRecordingListTransHolder  set [Mainstatus]=2
		--, OutStatus = 2
		delete dbo.tblRecordingListTransHolder 
			where RecordID= @RecordID and extension = '-Out.wav'; 
	else
		--update leg_icon_dev.dbo.tblRecordingListTransHolder  set [Mainstatus]=2
		--, Instatus = 2
		delete dbo.tblRecordingListTransHolder 
			where RecordID= @RecordID and extension = '-In.wav';
	end
 End
 
 
 
 

