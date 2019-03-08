
CREATE PROCEDURE [dbo].[SELECT_InmateByPIN2]
(
	@PIN varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT       PIN, InmateID, LastName, FirstName, MidName, Status, S.Descrip as [StatusDesc], DNIRestrict, DateTimeRestrict, AlertEmail, AlertCellPhones, AlertPhone, DNILimit, FacilityId,
			 MaxCallTime,HourlyFreq,DailyFreq,WeeklyFreq,MonthlyFreq, inputdate, UserName, ModifyDate, MaxCallPerHour, MaxCallPerDay, MaxCallPerWeek, MaxCallPerMonth, isnull(TTY,'0') as TTY
FROM            tblInmate I  with(nolock)  INNER JOIN tblStatus S   with(nolock) ON I.Status = S.statusID
WHERE PIN = @PIN AND  FacilityId = @FacilityId

