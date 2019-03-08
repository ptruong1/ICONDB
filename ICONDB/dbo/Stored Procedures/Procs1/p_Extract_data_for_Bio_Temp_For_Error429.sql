
CREATE PROCEDURE [dbo].[p_Extract_data_for_Bio_Temp_For_Error429]

As
BEGIN
	
	Declare @t2 table (UserID varchar(17));
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
	
	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricIdentification] I with(nolock)
		 where
		datediff(day,RecordDate,getdate()) = 0
		and transType in (1, 2) 
		and Note like '%(429)%'
		

	Select facilityId, RecordID, InmateId, PIN,
('\\' + UserName + '\home\ThirdPtDt_RmoteSver\' + ('ACP' + (PARSENAME([userName], 1))) + '\' + folderDate + '\') as directory, Replace(RecordFile, '.WAV', '-out.wav') as fileName,
duration 

from #temp 
	where InmateId not in (select LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) from @t2)
order by recordId			

	--select * from #temp where InmateId not in (select LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) from @t2)
	--order by facilityID, InmateId
		
	drop table #temp	
END
 
 
 
 
 

