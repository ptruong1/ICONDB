-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_Report_Inmate_List]
(
	@FacilityID int,
	@fromDate   smalldatetime,  --Required
	@toDate	smalldatetime,  --Required
	@InmateStatus int
)
AS
	SET NOCOUNT ON;
	If (@InmateStatus = -1)
SELECT        tblInmate.InmateID, dbo.fn_InitialCap(LastName) as LastName, dbo.fn_InitialCap(FirstName) as FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status], 
				DOB, tblSex.Descript as Sex, tblRaces.Descript as Race, tblInmate.InmateNote, CONVERT(VARCHAR(10), tblInmate.ActiveDate, 101) as DateBooked 
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
				inner join tblRaces on isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  
				inner join tblSex on isnull(tblInmate.Sex,'U') = tblSex.Sex  
				Left Join tblVisitInmateConfig On tblInmate.FacilityID = tblVisitInmateConfig.FacilityID
				and tblInmate.InmateID = tblVisitInmateConfig.InmateID 
	WHERE tblInmate.facilityID = @FacilityID and
	(tblInmate.InputDate between @fromDate and dateadd(d,1,@todate) ) 
		
	ORDER BY tblInmate.InputDate DESC
	else
	SELECT        tblInmate.InmateID, dbo.fn_InitialCap(LastName) as LastName, dbo.fn_InitialCap(FirstName) as FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status], 
				DOB, tblSex.Descript as Sex, tblRaces.Descript as Race, tblInmate.InmateNote, CONVERT(VARCHAR(10), tblInmate.ActiveDate, 101) as DateBooked  
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
				inner join tblRaces on isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  
				inner join tblSex on isnull(tblInmate.Sex,'U') = tblSex.Sex  
				Left Join tblVisitInmateConfig On tblInmate.FacilityID = tblVisitInmateConfig.FacilityID
				and tblInmate.InmateID = tblVisitInmateConfig.InmateID 
	WHERE tblInmate.facilityID = @FacilityID and
	(tblInmate.InputDate between @fromDate and dateadd(d,1,@todate) ) 
	and tblInmateStatus.statusID = @InmateStatus
	
	 ORDER BY tblInmate.InputDate DESC



