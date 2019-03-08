
CREATE PROCEDURE [dbo].[p_find_record_Path_ForTesting]
@RecordID  int,
@Path varchar(100) output

 AS

select    tblcallsbilled.RecordID,   
                           ( CASE channel 
		when 1 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 2 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 3 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 4 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 5 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 6 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 7 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 8 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		when 9 then  ComputerName +'\line0' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
		else  ComputerName +'\line' + cast(channel as varchar(2))+ '\' + folderdate +'\'+ projectCode+ '_' + folderdate + '.wav'  
	             end  )
	
from       tblACPs with(nolock) , tblcallsbilled with(nolock) 
where	tblcallsbilled.userName = tblACPs.IpAddress and tblcallsbilled.RecordID= @RecordID

