-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_InmateHadProfiles_Manual_Set]
AS
BEGIN
	select  I.FacilityID, I.InmateID, I.PIN, B.UserID, I.Status
	from tblBioMetricProfileOxfordVerification B
	inner join [leg_Icon].[dbo].tblInmate I 
	on LEFT(UserID,CHARINDEX('-',UserID)-1) = I.FacilityID and LTRIM(Right(UserID, Len(UserID) - CHARINDEX('-',UserID) )) = I.PIN 
	and I.status > 1
	inner join [leg_Icon].[dbo].tblFacilityOption O with(nolock) 
	on LEFT(UserID,CHARINDEX('-',UserID)-1) =  O.FacilityID and O.BioMetric=1

	order by I.facilityID
		
END

