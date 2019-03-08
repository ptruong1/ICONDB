-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Reset_Inmate_Has_No_Profile]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int);
	Declare @t1 table (facilityID int,UserID varchar(17));
	Declare @t2 table (UserID varchar(17));
	
	insert @t
	SELECT  I.FacilityID, I.InmateID, I.PIN, (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) as UserID, I.Status from
			[leg_Icon].[dbo].tblInmate I with(nolock) ,  [leg_Icon].[dbo].tblFacilityOption O with(nolock)  where
			I.FacilityId = O.FacilityID and
			I.BioRegister =1 and 
			I.Status = 1 and
			O.BioMetric=1 
			--and I.FacilityID = 670;

	Insert @t2
		select distinct  userID
		from  [leg_Icon].[dbo].[tblBioMetricProfileOxfordVerification] I with(nolock)
		 --where	userId like '670-%'
		

	select * from @t where userID not in (select userID from @t2)
	
		
END

