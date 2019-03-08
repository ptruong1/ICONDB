-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inactive_InmateHad_IdentifyProfiles]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int, PrimaryLanguage int);

	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID, isnull(PIN,'') as PIN, 
	[UserID], isnull(Status, 9) as Status, (select acpSelectOpt from [leg_Icon].[dbo].tblLanguages L where (isnull(B.LanguageSelected,'Uns')) = L.Abbrev) as PrimaryLanguage  

	FROM [leg_Icon].[dbo].[tblBioMetricProfileOxfordIdentification] B
	  cross apply  
	(select top 1 status, PIN from [leg_Icon].[dbo].[tblInmate] I
	  where facilityID = LEFT(B.UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	  order by inputDate) as LineItem2
	  inner join [leg_Icon].[dbo].tblFacilityOption O on LEFT(UserID,CHARINDEX('-',UserID)-1) = O.FacilityID 
	   where B.RemainEnrollments <> 0 
	  and datediff(day,B.ModifyDate,getdate()) > 10
	  and O.facilityID > 1 
	   and LEFT(UserID,CHARINDEX('-',UserID)-1) in (795)
	
	  Select * from @t
		
END

