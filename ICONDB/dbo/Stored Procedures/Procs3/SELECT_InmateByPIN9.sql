-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmateByPIN9]
(
	@PIN varchar(12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT       PIN, I.InmateID, LastName, FirstName, MidName, Status as StatusID, S.Descipt as [StatusDesc], DNIRestrict, DateTimeRestrict, AlertEmail, AlertCellPhones, AlertPhone, DNILimit, I.FacilityId,
			 MaxCallTime,HourlyFreq,DailyFreq,WeeklyFreq,MonthlyFreq, inputdate, UserName, ModifyDate, MaxCallPerHour, MaxCallPerDay, MaxCallPerWeek, MaxCallPerMonth, isnull(TTY,'0') as TTY,
			isnull(DebitCardOpt,'0') as DebitCardOpt, isnull(NameRecorded,'0') as NameRecorded, isnull(StartDate,getdate()) as StartDate, isnull(EndDate,getdate()) as EndDate, DOB, Sex, InputDate, AccessType,
			isnull(BlockPeriodOfTime,0) as BlockPeriodOfTime, isnull(PANNotAllow,0) as PANNotAllow, isnull(NotAllowLimit,0) as NotAllowLimit, isnull(AssignToDivision,'-1') as AssignToDivision,
			isnull(AssignToLocation,'-1') as AssignToLocation, isnull(AssignToStation,'-1') as AssignToStation, isnull(BioRegister,0) as BioRegister, isnull(NameRecorded,0) as NameRecorded,
			isnull(CustodialOpt,0) as CustodialOpt, 
			isnull(V.ApprovedReq,0) as ApprovedReq, 
			V.ExtID,
			V.SusStartDate,  
			V.SusEndDate, 
			V.AtLocation, 
			isnull(V.PAV,0) as PAV, 
			isnull(V.MaxVisitor,0) as MaxVisitor, 
			isnull(V.VisitPerDay,0) as VisitPerday, 
			ISNULL(V.VisitPerWeek,0) as VisitPerWeek, 
			isnull(V.VisitPerMonth,0) as VisitPerMonth,
			V.LocationID
			
FROM            tblInmate I  with(nolock)  
	INNER JOIN tblInmateStatus S   with(nolock) ON I.Status = S.statusID
	LEFT JOIN leg_Icon_dev.[dbo].[tblVisitInmateConfig] V   with(nolock) 
				ON V.FacilityID = I.FacilityId and
				   V.InmateID = I.InmateID
				
WHERE I.PIN = @PIN AND  I.FacilityId = @FacilityId

