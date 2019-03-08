
CREATE PROCEDURE [dbo].[p_get_recording_transcriptRequest]
@lastRecorID bigint, 
@WordsMatch	varchar(500),
@lastFilePath varchar(100),
@RecordID	bigint OUTPUT,
@FilePath	varchar(100) OUTPUT,
@keyWords	varchar(500) OUTPUT

As
SET NOCOUNT ON;
SET  @RecordID =0;

if(@lastRecorID >0)
 Begin
	if(select count(*) from leg_Icon.dbo.tblRecordingTransMatch where RecordID =@lastRecorID) =0
		Insert leg_Icon.dbo.tblRecordingTransMatch ( RecordID, WordsMatch) values(@lastRecorID,@WordsMatch);  -- match files
	else
		update leg_Icon.dbo.tblRecordingTransMatch set WordsMatch =WordsMatch + @WordsMatch where RecordID = @lastRecorID;
	Delete  leg_Icon.dbo.tbltempTranscript where RecordID =  @lastRecorID and RecordPath = @lastFilePath ;-- temp file being transcript
	Delete leg_Icon.dbo.tblRecordStack  where RecordID =  @lastRecorID and RecordPath = @lastFilePath; -- request
	update leg_Icon.dbo.tblRecordingListTrans set [status]=2, processTime=getdate() where RecordID= @lastRecorID ;
 End
select top 1  @RecordID= RecordID   ,  @FilePath  = RecordPath,   @keyWords  = keyswords from   leg_Icon.dbo.tblRecordStack with(nolock)  where
	          RecordPath  not in (  select RecordPath from leg_Icon.dbo.tbltempTranscript with (nolock) )    order by priority, RequestDate;

If(@RecordID >0)
  begin
	Insert   leg_Icon.dbo.tbltempTranscript(RecordID,RecordPath) values(@RecordID,@FilePath);
	return 0;
  end
else
  begin
	
		if(select count(*) from  tblRecordingTranscript with(nolock) where status = 0) > 0
		Begin 
			
			update  tblRecordingTranscript  set status =1 where   status = 0 ;
			
			Insert leg_Icon.dbo.tblRecordStack 
			select   tblcallsbilled.RecordID, tblcallsbilled.userName+ '\' + FolderDate + '\'  + CAST( tblcallsbilled.RecordID as Varchar(15))+'-in.wav', Words,  tblRecordingTranscript.inputdate , 1
			from tblRecordingListTrans with(nolock), tblRecordingTranscript with(nolock) , tblcallsbilled with(nolock) 
			 where tblRecordingListTrans.TranscriptListID = tblRecordingTranscript.TranscriptListID and tblRecordingTranscript.status =1 and
				tblcallsbilled.RecordId = tblRecordingListTrans.RecordID  and  
			     tblRecordingListTrans.status =0 
			 Order by  tblRecordingTranscript.TranscriptListID;
			 
			 Insert leg_Icon.dbo.tblRecordStack 
			select   tblcallsbilled.RecordID,tblcallsbilled.userName + '\' + FolderDate + '\' + CAST( tblcallsbilled.RecordID as Varchar(15)) +'-out.wav', Words,  tblRecordingTranscript.inputdate , 1
			from tblRecordingListTrans with(nolock), tblRecordingTranscript with(nolock) , tblcallsbilled with(nolock) 
			 where tblRecordingListTrans.TranscriptListID = tblRecordingTranscript.TranscriptListID and 
					tblRecordingTranscript.status =1 and
					 tblcallsbilled.RecordId = tblRecordingListTrans.RecordID  and   
					 tblRecordingListTrans.status =0 
			 Order by  tblRecordingTranscript.TranscriptListID;
			 
		End 
		
		select top 1  @RecordID= RecordID   ,  @FilePath  = RecordPath,   @keyWords  = keyswords from   leg_Icon.dbo.tblRecordStack with(nolock)  where
	          RecordID  not in (  select recordId from leg_Icon.dbo.tbltempTranscript with (nolock) )    order by priority, RequestDate;

		If(@RecordID >0)
		 begin
			Insert   leg_Icon.dbo.tbltempTranscript(RecordID,RecordPath) values(@RecordID,@FilePath);
			return 0;
		 end
		
	
  end
 
 
 
 

