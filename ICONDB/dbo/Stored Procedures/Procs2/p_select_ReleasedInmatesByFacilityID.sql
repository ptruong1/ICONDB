-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_ReleasedInmatesByFacilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        tblInmate.InmateID, tblInmate.InmateID as InmateID2, 
				case isnull(tblInmate.LastName,' ')
			   when ' ' then ' ' 
				else dbo.fn_InitialCap(tblInmate.LastName) end as LastName, 
				case isnull(tblInmate.FirstName,' ')
				   when ' ' then ' ' 
					else dbo.fn_InitialCap(tblInmate.FirstName) end as FirstName,
				PIN, MidName, tblInmateStatus.Descipt as [Status], 
				isnull(BioRegister,0) as BioRegister
				, isnull(NameRecorded,0) as NameRecorded, isnull(CustodialOpt,0) as CustodialOpt, 
				isnull(ApprovedReq,0) as VisitApprovedReq, DOB, tblSex.Descript as Sex, 
				tblRaces.Descript as Race, tblInmate.InmateNote 
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
				inner join tblRaces on isnull(tblInmate.RaceID, 0) = tblRaces.RaceID  
				inner join tblSex on isnull(tblInmate.Sex,'U') = tblSex.Sex  
				Left Join tblVisitInmateConfig On tblInmate.FacilityID = tblVisitInmateConfig.FacilityID
				and tblInmate.InmateID = tblVisitInmateConfig.InmateID 
	WHERE tblInmate.facilityID = @FacilityID and statusID =2
ORDER BY tblInmateStatus.Descipt asc, tblInmate.inputdate DESC


