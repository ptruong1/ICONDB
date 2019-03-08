-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_validate]
	@AgentID int,
	@FromDate datetime,
	@ToDate datetime
AS
BEGIN
	

	create table  #tempVal  (
				  OrigNumber char(10),
				  BillTonNumber varchar(16),
				 recordDate datetime
				  )

	Insert  #tempVal ( OrigNumber ,BillTonNumber ,recordDate)
		   select fromno, tono, recordDate from tblcallsunbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and billtype='01' and len(tono) =10 and left(tono,1) > 1 and FacilityID in (select FacilityID from tblfacility with(nolock) where AgentID = @AgentID); 

	Insert  #tempVal ( OrigNumber ,BillTonNumber ,recordDate )
		   select fromno, tono, recordDate  from tblcallsbilled with(nolock) 
			where RecordDate >= @FromDate and RecordDate <=@ToDate and billtype='01' and agentID =@AgentID; 


	select OrigNumber ,BillTonNumber ,recordDate, 0.055 as Cost from #tempVal order by recordDate ;



END

