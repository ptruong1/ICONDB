
CREATE PROCEDURE [dbo].[p_insert_recording_for_transcript]
@projectcode	char(6),
@calldate	char(6),
@RecordFileName	varchar(20)
 AS

If( @RecordFileName <>'')
	Insert tblRecordStack 
	select  tblcalls.RecordID, 
	(CASE channel 
	when 1 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 2 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 3 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 4 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 5 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 6 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 7 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 8 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	when 9 then ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	else ComputerName +'\line' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	end) as FilePath, keywords,getdate(),  2
	from   tblACPs with(nolock) , tblcalls with(nolock)  , tblFacilityKeyWords with(nolock) 
	where    tblcalls.userName = tblACPs.IpAddress  and
		tblcalls.FacilityID = tblFacilityKeyWords.facilityID and
		 tblcalls.projectcode =  @projectcode and 
		  tblcalls.calldate = @calldate

