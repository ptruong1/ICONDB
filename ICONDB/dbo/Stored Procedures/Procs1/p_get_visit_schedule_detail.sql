-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_schedule_detail]
@AccountNo varchar(12)	
AS
BEGIN
	select  ApmNo , InmateName , (VFirstName + '  ' + VLastName ) as   VisitorName ,  ApmDate , ApmTime   ,S.Descript [Status], T.VisitTypeID as VisitTypeID, T.Descript as VisitType,  LimitTime , TotalCharge
	from leg_Icon.dbo.tblVisitEnduserSchedule E,leg_Icon.dbo.tblVisitStatus S, leg_Icon.dbo.tblvisitors V ,leg_Icon.dbo.tblVisitType T
	where 
	E.visitorID = V.VisitorID AND
	E.visitType = T.VisitTypeID AND
	E.status = S.StatusID AND
	E.EndUserID = @AccountNo 
	order by RoomID desc

END


