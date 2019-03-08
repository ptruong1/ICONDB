-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID9]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        tblInmate.InmateID, tblInmate.InmateID as InmateID2, dbo.fn_InitialCap(tblInmate.LastName) as LastName, 
				dbo.fn_InitialCap(tblInmate.FirstName) as FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status], 
				isnull(BioRegister,0) as BioRegister
				, isnull(NameRecorded,0) as NameRecorded, isnull(CustodialOpt,0) as CustodialOpt, 
				isnull(ApprovedReq,0) as VisitApprovedReq, DOB, tblSex.Descript as Sex, 
				tblRaces.Descript as Race, tblInmate.InmateNote InmateNote
FROM            tblInmate with(nolock) INNER JOIN tblInmateStatus with(nolock) ON tblInmate.Status = tblInmateStatus.statusID
				inner join tblRaces with(nolock) on isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  
				inner join tblSex with(nolock) on isnull(tblInmate.Sex,'U') = tblSex.Sex  
				Left Join tblVisitInmateConfig with(nolock) On tblInmate.FacilityID = tblVisitInmateConfig.FacilityID
				and tblInmate.InmateID = tblVisitInmateConfig.InmateID 
	WHERE tblInmate.facilityID = @FacilityID
ORDER BY tblInmateStatus.Descipt asc, tblInmate.inputdate DESC


