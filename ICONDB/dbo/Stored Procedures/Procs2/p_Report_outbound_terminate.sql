-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_outbound_terminate]
	@AgentID int,
	@FromDate datetime,
	@ToDate datetime
AS
BEGIN
	

	create table  #tempTer  (
				 OrigNumber char(10),
				 TerNumber varchar(16),
				 ConnectDateTime datetime,
				 CallType varchar(2),
				 Duration smallint )

	Insert  #tempTer ( OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration)
		   select fromno, tono, recordDate,isnull( Calltype, 'RL'), CEILING(isnull((OutDuration/60.00),1)) from tblcallsunbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and (errorType in (2,3,22) or OutDuration >0)   and  FacilityID in (select FacilityID from tblfacility with(nolock) where AgentID = @AgentID); 

	Insert  #tempTer ( OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration)
		   select fromno, tono, recordDate,Calltype, CEILING(ACduration/60.00) from tblcallsbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and agentID =@AgentID; 


	select OrigNumber ,TerNumber,ConnectDateTime,Calltype, Duration, (CASE Calltype When 'IN' then 0.20 else  0.005 end) as Rate, (Duration * (CASE Calltype When 'IN' then 0.20 else  0.005 end)) as Cost
	  from #tempTer where Duration >0 order by ConnectDateTime ;



END

