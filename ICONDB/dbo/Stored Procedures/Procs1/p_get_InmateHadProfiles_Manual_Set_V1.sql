-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_InmateHadProfiles_Manual_Set_V1]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int);
	Declare @t1 table (facilityID int,UserID varchar(17));
	Declare @t2 table (UserID varchar(17));
	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, InmateID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as PIN, 
	[UserID], isnull(I.Status, 9) as Status 
	from [leg_Icon].[dbo].[tblBioMetricProfileOxfordVerification]
	left join [leg_Icon].[dbo].[tblInmate] I  on 
	  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
	  and I.PIN = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	
 
	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricTransOxford] I with(nolock)
		 where
		datediff(day,RecordDate,getdate()) <=15
		and transType in (1, 2);
		

	select * from @t where userID not in (select userID from @t2)
		

	
		
END

