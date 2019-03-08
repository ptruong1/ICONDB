
CREATE PROCEDURE [dbo].[p_Extract_data_for_Bio_Temp_RunParallel]

As
declare @facilityId int, @yesterday dateTime
set @facilityId = 795
set @yesterday = dateadd(day,-1, cast(getdate() as date)) -- get date and time dateadd(day,-1, getdate())
SELECT  C.facilityId, C.RecordID, C.FolderDate, C.userName, InmateId, PIN,
 RecordFile, duration
  into #temp           
			  from tblCallsBilled C 
		where facilityId = @facilityId	and (RecordDate between @yesterday and dateadd(d,1,@yesterday) )  
		and duration > 300 
		order by recordDate asc
		--and InmateId not in ('151432','22778','26035','68418', '156733', '3105')


Select facilityId, RecordID, InmateId, PIN,
('\\' + UserName + '\home\ThirdPtDt_RmoteSver\' + ('ACP' + (PARSENAME([userName], 1))) + '\' + folderDate + '\') as directory, Replace(RecordFile, '.WAV', '-out.wav') as fileName,
duration 


from #temp 
order by recordId

drop table #temp
 
 
 
 
 

