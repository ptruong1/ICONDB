-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_InmateHadProfiles_Manual_Set_VoiceIT]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), UserID varchar(17), Status int);
	--Declare @t1 table (facilityID int,UserID varchar(17));
	Declare @t2 table (UserID varchar(17));
	insert @t
	SELECT  LEFT(UserID,CHARINDEX('-',UserID)-1) as facilityID, LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) )) as InmateID, 
	[UserID], isnull(I.Status, 9) as Status 
	from [leg_Icon].[dbo].[tblBioMetricProfileVoiceITVerification]
	left join [leg_Icon].[dbo].[tblInmate] I  on 
	  I.facilityID = LEFT(UserID,CHARINDEX('-',UserID)-1)
	  and I.InmateID = LTRIM(RIGHT(UserID,LEN(UserID) - CHARINDEX('-',UserID) ))
	
 
	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricVoiceIT_Trans] I with(nolock)
		 where
		datediff(day,InputDate,getdate()) <=15
		and transType in (1, 2)
				

	select * from @t where userID not in (select userID from @t2)
	
		
END

