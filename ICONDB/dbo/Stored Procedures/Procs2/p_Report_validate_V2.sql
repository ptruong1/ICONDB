-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[p_Report_validate_V2]
	@AgentID int,
	@FromDate datetime,
	@ToDate datetime
AS
BEGIN
	
	create table  #tempVal  (
				  FacilityId int,
				  OrigNumber char(10),
				  BillTonNumber varchar(16),
				 recordDate datetime,
				 RecNo smallInt
				  )

	Insert  #tempVal (FacilityId, OrigNumber ,BillTonNumber ,recordDate, recNo)
		   select FacilityId, fromno, tono, recordDate, 1 from tblcallsunbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and billtype='01' and FacilityID in (select FacilityID from tblfacility with(nolock) where AgentID = @AgentID); 

	Insert  #tempVal (FacilityId, OrigNumber ,BillTonNumber ,recordDate, recNo)
		   select facilityId, fromno, tono, recordDate, 1  from tblcallsbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and billtype='01' and agentID =102; 
							
	create table  #tempVal2  (
				  FacilityId int,
				  OrigNumber char(10),
				  BillTonNumber varchar(24),
				 recordDate datetime,
				 Cost decimal(5,3),
				 RecNo smallInt
				  )

	Insert  #tempVal2 (FacilityId, OrigNumber ,BillTonNumber ,recordDate, Cost, recNo)
	select facilityId, OrigNumber ,BillTonNumber ,recordDate, (0.055) as Cost, recNo from #tempVal 
	
	Insert  #tempVal2 (FacilityId, OrigNumber ,BillTonNumber ,recordDate, Cost, recNo)
	select facilityId, '' OrigNumber , 'Total By Facility' BillTonNumber , Null recordDate, sum(0.055) as Cost, 2 from #tempVal 
	group by facilityId

	Insert  #tempVal2 (FacilityId, OrigNumber ,BillTonNumber ,recordDate, Cost, recNo)
	select 9999, '' OrigNumber , 'Total All Facilities' BillTonNumber ,Null recordDate, sum(0.055) as Cost, 3 from #tempVal
	group by RecNo

	select *  from #tempVal2
	order by facilityId, recNo

	--create table  #tempVal  (
	--			  FacilityId int,
	--			  OrigNumber char(10),
	--			  BillTonNumber varchar(16),
	--			 recordDate datetime
	--			  )

	--Insert  #tempVal (FacilityId, OrigNumber ,BillTonNumber ,recordDate)
	--	   select FacilityId, fromno, tono, recordDate from tblcallsunbilled with(nolock) 
	--		where RecordDate >= @FromDate and RecordDate <=@ToDate and billtype='01' and FacilityID in (select FacilityID from tblfacility with(nolock) where AgentID = @AgentID); 

	--Insert  #tempVal (FacilityId, OrigNumber ,BillTonNumber ,recordDate)
	--	   select facilityId, fromno, tono, recordDate  from tblcallsbilled with(nolock) 
	--		where RecordDate >= @FromDate and RecordDate <=@ToDate and billtype='01' and agentID =102; 


	--select facilityId, OrigNumber ,BillTonNumber ,recordDate, 0.055 as Cost from #tempVal order by facilityId, recordDate ;



END

