
CREATE PROCEDURE [dbo].[p_Insert_TransMatch_v1]
@RecordID	bigint,
@WordsMatch	varchar(500),
@CallerText nvarchar(4000),
@CalleeText nvarchar(4000)

As
SET NOCOUNT ON;

Begin
	if(select count(*) from leg_Icon.dbo.tblRecordingTransMatch where RecordID =@RecordID) =0
		Insert leg_Icon.dbo.tblRecordingTransMatch ( RecordID, WordsMatch,CalleeText,CallerText) values(@RecordID,@WordsMatch,@CalleeText,@CallerText);  -- match files
	else
	begin
	if @CallerText <> ''
		update leg_Icon.dbo.tblRecordingTransMatch 
		set
		 WordsMatch = @WordsMatch
		--, CalleeText= @CalleeText
		,CallerText=  @CallerText 
		 where RecordID = @RecordID;
	else
		 update leg_Icon.dbo.tblRecordingTransMatch 
		set
		 WordsMatch = @WordsMatch
		, CalleeText= @CalleeText
		--,CallerText=  @CallerText 
		 where RecordID = @RecordID;
	end
	update leg_Icon.dbo.tblRecordingListTrans set [status]=2, processTime=getdate() where RecordID= @RecordID ;
 End
 
 
 
 

