-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID6]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        tblInmate.InmateID, LastName, FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status], isnull(BioRegister,0) as BioRegister
				, isnull(NameRecorded,0) as NameRecorded, isnull(CustodialOpt,0) as CustodialOpt, 
				isnull(ApprovedReq,0) as VisitApprovedReq
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
				Left Join tblVisitInmateConfig On tblInmate.FacilityID = tblVisitInmateConfig.FacilityID
				and tblInmate.InmateID = tblVisitInmateConfig.InmateID 
	WHERE tblInmate.facilityID = @FacilityID
ORDER BY tblInmate.inputdate DESC


