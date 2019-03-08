-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_InmatesByFacilityID4]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        InmateID, LastName, FirstName, PIN, MidName, tblInmateStatus.Descipt as [Status], isnull(BioRegister,0) as BioRegister
				, isnull(NameRecorded,0) as NameRecorded
FROM            tblInmate INNER JOIN tblInmateStatus ON tblInmate.Status = tblInmateStatus.statusID
WHERE facilityID = @FacilityID
ORDER BY inputdate DESC

