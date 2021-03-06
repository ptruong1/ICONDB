﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_InmateHadProfiles_Manual_Set_06272017]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int, PrimaryLanguage int);
	Declare @t2 table (UserID varchar(17));
	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, Isnull(InmateID, ' ') as InmateID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as PIN, 
	[UserID], isnull(I.Status, 9) as Status, isnull(I.PrimaryLanguage, 0) as PrimaryLanguge 
	from [leg_Icon].[dbo].[tblBioMetricProfileOxfordVerification] B
	left join [leg_Icon].[dbo].[tblInmate] I  on 
	  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
	  and I.PIN = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))

	  where LEFT(UserID,CHARINDEX('-',UserID)-1)  in (1, 558, 670, 686, 691, 701, 747, 781, 782)
	  
	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID,  I.PIN, 
	[UserID], isnull(I.Status, 9) as Status, isnull(I.PrimaryLanguage, 0) as PrimaryLanguge 
	from [leg_Icon].[dbo].[tblBioMetricProfileOxfordVerification] B
	left join [leg_Icon].[dbo].[tblInmate] I  on 
	  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	  where LEFT(UserID,CHARINDEX('-',UserID)-1) not in (1, 558, 670, 686, 691, 701, 747, 781, 782)
	
	
	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID, PIN,
	[UserID], isnull(I.Status, 9) as Status, isnull(I.PrimaryLanguage, 0) as PrimaryLanguge 
	from [leg_Icon].[dbo].tblBioMetricProfileVoiceITVerification
	left join [leg_Icon].[dbo].[tblInmate] I  on 
	  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
 
	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricTransOxford] I with(nolock)
		 where
		datediff(day,RecordDate,getdate()) <=15
		and transType in (1, 2)

	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricVoiceIT_Trans] I with(nolock)
		 where
		datediff(day,InputDate,getdate()) <=15
		and transType in (1, 2)
				

	select * from @t where userID not in (select userID from @t2)
	order by facilityID, PIN
	--and facilityID = 686
		

	
		
END

