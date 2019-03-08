-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_visit_schedule_detail_Past]
@AccountNo varchar(12)	
AS
BEGIN
	Declare @localTime datetime, @timeZone tinyint
	SET @timeZone=0
	Select @timeZone = timezone from tblfacility inner join tblprepaid 
				on tblfacility.FacilityID =tblprepaid.FacilityID 
				where tblprepaid.PhoneNo= @AccountNo
	SET  @localTime = DATEADD (hour , @timeZone,getdate())
	select  ApmNo , InmateName , (VFirstName + '  ' + VLastName ) as   VisitorName ,  ApmDate , ApmTime   ,S.Descript [Status], T.VisitTypeID as VisitTypeID, T.Descript as VisitType,  LimitTime ,TotalCharge
	from leg_Icon.dbo.tblVisitEnduserSchedule E,leg_Icon.dbo.tblVisitStatus S, leg_Icon.dbo.tblvisitors V ,leg_Icon.dbo.tblVisitType T
	where 
	E.visitorID = V.VisitorID AND
	E.visitType = T.VisitTypeID AND
	E.status = S.StatusID AND
	E.EndUserID = @AccountNo AND
	DATEADD(Minute,E.LimitTime , DateAdd(minute, datepart(MINUTE ,E.ApmTime), dateadd(hour, datepart(HOUR,E.ApmTime), E.ApmDate))) >  @localTime
	order by ApmDate Asc
	
END


