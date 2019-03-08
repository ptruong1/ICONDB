-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inactive_InmateHadIdentifyProfiles_Manual]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int, PrimaryLanguage int);
	Declare @t2 table (UserID varchar(17));
	insert @t

	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID,  PIN, 
	[UserID], isnull(Status, 9) as Status, (select acpSelectOpt from [leg_Icon].[dbo].tblLanguages L where (isnull(B.LanguageSelected,'Uns')) = L.Abbrev) as PrimaryLanguage
	from [leg_Icon].[dbo].[tblBioMetricProfileOxfordIdentification] B
	cross apply  
	(select top 1 status, PIN from [leg_Icon].[dbo].[tblInmate] I
	  where facilityID = LEFT(B.UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	  order by inputDate) as LineItem2

	  where LEFT(UserID,CHARINDEX('-',UserID)-1) in (795)
	
	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricIdentification] I with(nolock)
		 where
		datediff(day,RecordDate,getdate()) <=15
		and transType in (1, 2)

				

	select * from @t where userID not in (select userID from @t2)
	order by facilityID, InmateId
		
		
END

