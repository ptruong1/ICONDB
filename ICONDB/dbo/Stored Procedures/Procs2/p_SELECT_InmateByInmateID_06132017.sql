-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_SELECT_InmateByInmateID_06132017]
(
	@InmateID varchar(12),
	@PIN varchar (12),
	@FacilityId int
)
AS
	SET NOCOUNT ON;
SELECT       I.PIN, I.InmateID, dbo.fn_InitialCap(I.LastName) as LastName, dbo.fn_InitialCap(I.FirstName) as FirstName, dbo.fn_InitialCap(I.MidName) as MidName, I.Status as StatusID, S.Descipt as [StatusDesc], DNIRestrict, DateTimeRestrict, AlertEmail, AlertCellPhones, AlertPhone, DNILimit, I.FacilityId,
			 MaxCallTime,HourlyFreq,DailyFreq,WeeklyFreq,MonthlyFreq, I.inputdate, UserName, isNull(I.ModifyDate,I.InputDate) as ModifyDate, MaxCallPerHour, MaxCallPerDay, MaxCallPerWeek, MaxCallPerMonth, isnull(TTY,'0') as TTY,
			isnull(DebitCardOpt,'0') as DebitCardOpt, isnull(NameRecorded,'0') as NameRecorded, isnull(StartDate,getdate()) as StartDate, isnull(EndDate,getdate()) as EndDate, I.DOB, isnull(I.Sex,'U') as Sex, I.InputDate, AccessType,
			isnull(BlockPeriodOfTime,0) as BlockPeriodOfTime, isnull(PANNotAllow,0) as PANNotAllow, isnull(NotAllowLimit,0) as NotAllowLimit, isnull(AssignToDivision,'-1') as AssignToDivision,
			isnull(AssignToLocation,'-1') as AssignToLocation, isnull(AssignToStation,'-1') as AssignToStation, isnull(BioRegister,0) as BioRegister, isnull(NameRecorded,0) as NameRecorded,
			isnull(CustodialOpt,0) as CustodialOpt, 
			isnull(V.ApprovedReq,0) as ApprovedReq,
			isNull(I.RaceID,0) as RaceID,
			I.AdminNote,
			I.InmateNote,
			isNull(I.FreeCallRemain,0) as FreeCallRemain,
			V.ExtID,
			V.SusStartDate,  
			V.SusEndDate, 
			V.AtLocation, 
			isnull(V.PAV,0) as PAV, 
			isnull(V.MaxVisitor,0) as MaxVisitor, 
			isnull(V.VisitPerDay,1) as VisitPerday, 
			ISNULL(V.VisitPerWeek,4) as VisitPerWeek, 
			isnull(V.VisitPerMonth,10) as VisitPerMonth,
			isnull(V.MaxVisitTime,0) as MaxVisitTime,
			isnull(V.LocationID,'-1') as LocationID,
			V.VNote,
			isnull(V.VisitRemain,10) as VisitRemain,
			PrimaryLanguage,
			(Select isnull(FormsOpt,0) from [leg_Icon].[dbo].[tblFacilityOption] where facilityID = @FacilityID) as FormsOpt
			
FROM            tblInmate I  with(nolock)  
	INNER JOIN tblInmateStatus S   with(nolock) ON I.Status = S.statusID
	LEFT JOIN leg_Icon.[dbo].[tblVisitInmateConfig] V   with(nolock) 
				ON V.FacilityID = I.FacilityId and
				   V.InmateID = I.InmateID
				
WHERE I.InmateID = @InmateID AND  I.FacilityId = @FacilityId and I.PIN = @PIN

