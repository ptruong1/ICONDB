

CREATE PROCEDURE [dbo].[p_Select_TroubleTicketDetails]
(
		@TicketID int
	)	
AS
	SET NOCOUNT OFF;

SELECT LegacyDetailNote, ReplyDetailNote, UserName, ReplyDate,
isnull(ServiceLevelID,1) as LevelID, isnull(AssignDeptID,1) as DeptID
             FROM tblTroubleTicketDetail
--             INNER JOIN tblServiceLevel ON isnull(tblTroubleTicket.ServiceLevelID,1) = tblServiceLevel.LevelID 
--                        INNER JOIN tblServiceDept ON isnull(tblTroubleTicket.AssignDeptID,1) = tblServiceDept.DeptID 
--WHERE TicketID = @TicketID 
ORDER BY ReplyDate DESC

