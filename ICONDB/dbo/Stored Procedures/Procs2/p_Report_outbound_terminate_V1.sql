-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_outbound_terminate_V1]
	@AgentID int,
	@FromDate datetime,
	@ToDate datetime
AS
BEGIN
	
	create table  #tempTer  (
				 facilityId int,
				 OrigNumber char(10),
				 TerNumber varchar(16),
				 ConnectDateTime datetime,
				 CallType varchar(50),
				 Duration smallint,
				 recNo smallint)

	Insert  #tempTer (FacilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration, recNo)
		   select facilityId, fromno, tono, recordDate, 
		   (Select Descript from tblCalltype where isnull( tblcallsUnbilled.Calltype, 'RL') = tblCallType.Abrev) as CallType, 
		   CEILING(isnull(OutDuration/60.0,1)), 1 from tblcallsunbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and (errorType in (2,3,22) or OutDuration >0)  and FacilityID in (select FacilityID from tblfacility with(nolock) where AgentID = @AgentID); 

	Insert  #tempTer ( facilityId, OrigNumber ,TerNumber,ConnectDateTime, Calltype, Duration, recNo)
		   select facilityId, fromno, tono, recordDate,
		   (Select Descript from tblCalltype where tblcallsbilled.CallType = tblCallType.Abrev) as Calltype, 
		   CEILING(AcDuration/60.00), 1 from tblcallsbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and agentID =102; 

	create table  #tempTer2  (
				 facilityId int,
				 OrigNumber char(10),
				 TerNumber varchar(16),
				 ConnectDateTime datetime,
				 CallType varchar(50),
				 Duration int,
				 Rate decimal(5,3),
				 cost decimal(5,2),
				 recNo smallint)

	Insert  #tempTer2 ( facilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration, Rate, Cost, recNo)
	select facilityId, OrigNumber ,TerNumber,ConnectDateTime, Calltype, Duration, (CASE Calltype When 'IN' then 0.20 else  0.005 end) as Rate, 
	(Duration * (CASE Calltype When 'IN' then 0.20 else  0.005 end)) as Cost, recNo  from #tempTer 
	
	Insert  #tempTer2 ( facilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration, Rate, Cost, recNo)
	select facilityId, '' OrigNumber ,'' TerNumber, Null ConnectDateTime, 'Total By Facility' Calltype, sum(Duration) as Duration, Null Rate, 
	sum(Duration * (CASE Calltype When 'IN' then 0.20 else  0.005 end)) as Cost, 2  from #tempTer
	group by facilityId

	Insert  #tempTer2 ( facilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration, Rate, Cost, recNo)
	select 9999 as facilityId, '' OrigNumber ,'' TerNumber, Null ConnectDateTime, 'Total All Facilities' Calltype, sum(Duration) as Duration, Null Rate, 
	sum(Duration * (CASE Calltype When 'IN' then 0.20 else  0.005 end)) as Cost, 3  from #tempTer
	group by RecNo

	select * from #tempTer2 where Duration >0
	order by facilityId, recNo, ConnectDateTime


	--create table  #tempTer  (
	--			 facilityId int,
	--			 OrigNumber char(10),
	--			 TerNumber varchar(16),
	--			 ConnectDateTime datetime,
	--			 CallType varchar(2),
	--			 Duration smallint )

	--Insert  #tempTer (FacilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration)
	--	   select facilityId, fromno, tono, recordDate,isnull( Calltype, 'RL'), isnull(OutDuration,1) from tblcallsunbilled with(nolock) 
	--		where RecordDate >= @FromDate and RecordDate <=@ToDate and errorType in (2,3) and FacilityID in (select FacilityID from tblfacility with(nolock) where AgentID = @AgentID); 

	--Insert  #tempTer ( facilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration)
	--	   select facilityId, fromno, tono, recordDate,Calltype, CEILING(duration/60.00) from tblcallsbilled with(nolock) 
	--		where RecordDate >= @FromDate and RecordDate <=@ToDate and agentID =102; 


	--select facilityId, OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration, (CASE Calltype When 'IN' then 0.20 else  0.005 end) as Rate, (Duration * 0.005) as Cost  from #tempTer 
	--order by facilityId, ConnectDateTime ;



END

