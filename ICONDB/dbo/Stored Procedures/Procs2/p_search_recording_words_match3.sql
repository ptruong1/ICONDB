
CREATE PROCEDURE [dbo].[p_search_recording_words_match3]
@TranscriptID	int,
@facilityID	int,
@fromDate	varchar(10),
@toDate	varchar(10)
As
SET NOCOUNT OFF 
Declare @inputDate datetime
SET  @inputDate = getdate()
--if ( @toDate is null or @toDate ='')  SET @toDate = getdate()
if(@fromDate <> '')
	Begin
         
		if(@TranscriptID > 0) 
			Begin 
				if( select count ( tblcallsbilled.RecordID) from  tblRecordingListTrans with(nolock) , tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock)
					
				 where  tblcallsbilled.userName = tblACPs.IpAddress and
					 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID  and tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID
					and  tblRecordingListTrans.TranscriptListID = @TranscriptID) > 0
					select   tblcallsbilled.RecordID, fromNo, ToNo, RecordDate, Calltype, Billtype, Duration, WordsMatch,
					tblRecordingTransMatch.CallerText, tblRecordingTransMatch.CalleeText, tblRecordingTranscript.Words,
						 (CASE channel 
						when 1 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 2 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 3 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 4 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 5 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 6 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 7 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 8 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 9 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						else ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						end)   as RecordingFile
					from  tblRecordingListTrans with(nolock) , tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock),
					[leg_Icon].[dbo].tblRecordingTranscript with(nolock)
						
					 where  tblcallsbilled.userName = tblACPs.IpAddress and
						 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID  and 
						 tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID and
						 tblRecordingTranscript.TranscriptListID = tblRecordingListTrans.TranscriptListID 
						and  tblRecordingListTrans.TranscriptListID = @TranscriptID  and 
						(RecordDate between @fromDate and dateadd(d,1,@todate) )  
				else 
					  Select    1 RecordID, '0000000000'  fromNo,'0000000000' ToNo, '8/4/2009' RecordDate , 'LC'  CallType,'01'  BillType, 1  Duration, 'Transcription request is processing'  WordsMatch, 'Unknown'  RecordingFile 
			End
			else
				select   tblcallsbilled.RecordID as RecordID, fromNo, ToNo, RecordDate, Calltype, Billtype, Duration, WordsMatch,
				tblRecordingTransMatch.CallerText, tblRecordingTransMatch.CalleeText, tblRecordingTranscript.Words,
					 (CASE channel 
					when 1 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 2 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 3 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 4 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 5 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 6 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 7 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 8 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 9 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					else ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					end)  RecordingFile
				from    tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock),
				 [leg_Icon].[dbo].tblRecordingListTrans with(nolock),
				[leg_Icon].[dbo].tblRecordingTranscript with(nolock)
				 where  	 tblcallsbilled.userName = tblACPs.IpAddress and
				 tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID and
					tblRecordingTranscript.TranscriptListID = tblRecordingListTrans.TranscriptListID and
					 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID and  
					 tblcallsbilled.facilityId = @facilityID  
	
	end
else  if(@fromDate = ''  and @toDate <>'' )
	begin 
		
		if(@TranscriptID > 0) 
			Begin 
				if( select count ( tblcallsbilled.RecordID) from  tblRecordingListTrans with(nolock) , tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock)
					
				 where  tblcallsbilled.userName = tblACPs.IpAddress and
					 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID  and tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID
					and  tblRecordingListTrans.TranscriptListID = @TranscriptID) > 0
					select   tblcallsbilled.RecordID, fromNo, ToNo, RecordDate, Calltype, Billtype, Duration, WordsMatch,
					tblRecordingTransMatch.CallerText, tblRecordingTransMatch.CalleeText, tblRecordingTranscript.Words,
						 (CASE channel 
						when 1 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 2 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 3 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 4 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 5 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 6 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 7 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 8 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 9 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						else ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						end)   as RecordingFile
					from  tblRecordingListTrans with(nolock) , tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock),
						[leg_Icon].[dbo].tblRecordingTranscript with(nolock)
					 where  tblcallsbilled.userName = tblACPs.IpAddress and
						 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID  and 
						 tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID and
						 tblRecordingTranscript.TranscriptListID = tblRecordingListTrans.TranscriptListID and
						  tblRecordingListTrans.TranscriptListID = @TranscriptID and	
						RecordDate < dateadd(d,1,@todate) 
				else 
					  Select    0 RecordID, '0000000000'  fromNo,'0000000000' ToNo, 'N/A' RecordDate , 'N/A'  CallType,'N/A'  BillType, 0  Duration, 'Transcript request is processing'  WordsMatch, 'Unknown'  RecordingFile 
			End
			else
				select   tblcallsbilled.RecordID as RecordID, fromNo, ToNo, RecordDate, Calltype, Billtype, Duration, WordsMatch,
				tblRecordingTransMatch.CallerText, tblRecordingTransMatch.CalleeText, tblRecordingTranscript.Words,
					 (CASE channel 
					when 1 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 2 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 3 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 4 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 5 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 6 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 7 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 8 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 9 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					else ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					end)  RecordingFile
				from    tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock),
				[leg_Icon].[dbo].tblRecordingListTrans with(nolock),
				[leg_Icon].[dbo].tblRecordingTranscript with(nolock)
				 where  	 tblcallsbilled.userName = tblACPs.IpAddress and
					 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID and 
					 tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID and
					tblRecordingTranscript.TranscriptListID = tblRecordingListTrans.TranscriptListID and 
					 tblcallsbilled.facilityId = @facilityID  
	
	end
else
begin 
		if(@TranscriptID > 0) 
			Begin 
				if( select count ( tblcallsbilled.RecordID) from  tblRecordingListTrans with(nolock) , tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock)
					
				 where  tblcallsbilled.userName = tblACPs.IpAddress and
					 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID  and tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID
					and  tblRecordingListTrans.TranscriptListID = @TranscriptID) > 0
					select   tblcallsbilled.RecordID, fromNo, ToNo, RecordDate, Calltype, Billtype, Duration, WordsMatch,
					tblRecordingTransMatch.CallerText, tblRecordingTransMatch.CalleeText, tblRecordingTranscript.Words,
						 (CASE channel 
						when 1 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 2 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 3 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 4 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 5 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 6 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 7 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 8 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						when 9 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						else ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
						end)   as RecordingFile
					from  tblRecordingListTrans with(nolock) , tblACPs with(nolock) , tblcallsbilled with(nolock)  , tblRecordingTransMatch  with(nolock),
					[leg_Icon].[dbo].tblRecordingTranscript with(nolock)
						
					 where  tblcallsbilled.userName = tblACPs.IpAddress and
						 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID  and 
						 tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID and
						 tblRecordingTranscript.TranscriptListID = tblRecordingListTrans.TranscriptListID 					 
						and  tblRecordingListTrans.TranscriptListID = @TranscriptID
				else 
					  Select    1 RecordID, '0000000000'  fromNo,'0000000000' ToNo, '8/4/2009' RecordDate , 'LC'  CallType,'01'  BillType, 1  Duration, 'Transcription request is processing'  WordsMatch, 'Unknown'  RecordingFile 
			End
			else
				select   tblcallsbilled.RecordID as RecordID, fromNo, ToNo, RecordDate, Calltype, Billtype, Duration, WordsMatch,
				tblRecordingTransMatch.CallerText, tblRecordingTransMatch.CalleeText, tblRecordingTranscript.Words,
					 (CASE channel 
					when 1 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 2 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 3 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 4 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 5 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 6 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 7 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 8 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					when 9 then ComputerName +'\line00' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					else ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ RecordFile
					end)  RecordingFile
				from    [leg_Icon].[dbo].tblACPs with(nolock) , [leg_Icon].[dbo].tblcallsbilled with(nolock)  , 
				[leg_Icon].[dbo].tblRecordingTransMatch  with(nolock), [leg_Icon].[dbo].tblRecordingListTrans with(nolock),
				[leg_Icon].[dbo].tblRecordingTranscript with(nolock)
				 where  	 tblcallsbilled.userName = tblACPs.IpAddress and
					tblRecordingTransMatch.RecordID = tblRecordingListTrans.RecordID and
					tblRecordingTranscript.TranscriptListID = tblRecordingListTrans.TranscriptListID and
					 tblcallsbilled.RecordId = tblRecordingTransMatch.RecordID 
					 and  tblcallsbilled.facilityId = @facilityID  
	end

