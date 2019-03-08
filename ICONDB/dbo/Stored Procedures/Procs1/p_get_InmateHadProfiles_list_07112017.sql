-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_InmateHadProfiles_list_07112017]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int, PrimaryLanguage int);

	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, Isnull(InmateID, ' ') as InmateID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as PIN, 
	[UserID], isnull(I.Status, 9) as Status, (select acpSelectOpt from [leg_Icon].[dbo].tblLanguages L where (isnull(B.LanguageSelected,'Uns')) = L.Abbrev) as PrimaryLanguage 

	FROM [leg_Icon].[dbo].[tblBioMetricProfileOxfordVerification] B
	  left join [leg_Icon].[dbo].[tblInmate] I  on 
	  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
	  and I.PIN = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	  inner join [leg_Icon].[dbo].tblFacilityOption O on LEFT(UserID,CHARINDEX('-',UserID)-1) = O.FacilityID 
	   where B.RemainEnrollments <> 0 
	  and datediff(day,B.ModifyDate,getdate()) > 10
	  and O.facilityID > 1 
	   and LEFT(UserID,CHARINDEX('-',UserID)-1)  in (1, 558, 670, 686, 691, 701, 747, 781, 782)

	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID, isnull(PIN,'') as PIN, 
	[UserID], isnull(Status, 9) as Status, (select acpSelectOpt from [leg_Icon].[dbo].tblLanguages L where (isnull(B.LanguageSelected,'Uns')) = L.Abbrev) as PrimaryLanguage  

	FROM [leg_Icon].[dbo].[tblBioMetricProfileOxfordVerification] B
	  cross apply  
	(select top 1 status, PIN from [leg_Icon].[dbo].[tblInmate] I
	  where facilityID = LEFT(B.UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	  order by inputDate) as LineItem2

	  inner join [leg_Icon].[dbo].tblFacilityOption O on LEFT(UserID,CHARINDEX('-',UserID)-1) = O.FacilityID 
	   where B.RemainEnrollments <> 0 
	  and datediff(day,B.ModifyDate,getdate()) > 10
	  and O.facilityID > 1 
	   and LEFT(UserID,CHARINDEX('-',UserID)-1) not in (1, 558, 670, 686, 691, 701, 747, 781, 782)
	
	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID, PIN, 
	[UserID], isnull(Status, 9) as Status, (select acpSelectOpt from [leg_Icon].[dbo].tblLanguages L where (isnull(B.LanguageSelected,'Uns')) = L.Abbrev) as PrimaryLanguage  
	from [leg_Icon].[dbo].tblBioMetricProfileVoiceITVerification B
	cross apply  
	(select top 1 status, PIN from [leg_Icon].[dbo].[tblInmate] I
	  where facilityID = LEFT(B.UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	  order by inputDate) as LineItem2

	  inner join [leg_Icon].[dbo].tblFacilityOption O on LEFT(UserID,CHARINDEX('-',UserID)-1) = O.FacilityID 
	   where B.RemainEnrollments <> 0 
	  and datediff(day,B.ModifyDate,getdate()) > 10
	  and O.facilityID > 1 

	  Select * from @t
		
END

