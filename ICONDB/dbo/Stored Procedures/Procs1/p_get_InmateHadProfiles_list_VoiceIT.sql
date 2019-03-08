-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_InmateHadProfiles_list_VoiceIT]
AS
BEGIN
	SELECT LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, 
	LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID, 
	[UserID], isnull(I.Status, 9) as Status
    
	  
  FROM [leg_Icon].[dbo].[tblBioMetricProfileVoiceITVerification] B
  left join [leg_Icon].[dbo].[tblInmate] I  on 
  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
  inner join [leg_Icon].[dbo].tblFacilityOption O on LEFT(UserID,CHARINDEX('-',UserID)-1) = O.FacilityID 
   where B.RemainEnrollments <> 0 
  and datediff(day,B.ModifyDate,getdate()) > 10
  and O.facilityID > 1 
	
		
END

