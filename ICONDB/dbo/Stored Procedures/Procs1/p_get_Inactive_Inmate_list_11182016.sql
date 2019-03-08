-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inactive_Inmate_list_11182016]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int);
	Declare @t1 table (facilityID int,UserID varchar(17));
	insert @t
	SELECT  I.FacilityID, I.InmateID, I.PIN, (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) as UserID, I.Status from
			[leg_Icon].[dbo].tblInmate I with(nolock) ,  [leg_Icon].[dbo].tblFacilityOption O with(nolock)  where
			I.FacilityId = O.FacilityID and
			I.BioRegister =1 and 
			I.Status >1 and
			O.BioMetric=1 ;
    if(@@ROWCOUNT >0)
		select * from @t ; 
	--else
	-- begin
	--	insert @t
	--	SELECT  I.FacilityID, I.InmateID, I.PIN, (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) as UserID, I.Status from
	--			[leg_Icon].[dbo].tblInmate I with(nolock) ,  [leg_Icon].[dbo].tblFacilityOption O with(nolock)  where
	--			I.FacilityId = O.FacilityID and I.FacilityId = 686 and
	--			I.BioRegister =1 and 
	--			I.Status =1 and
	--			O.BioMetric=1 ;
	--	Insert @t1
	--	select distinct  I.facilityID, (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) 
	--	from  [leg_Icon].[dbo].tblCallsBilled I with(nolock),  [leg_Icon].[dbo].tblFacilityOption O with(nolock)  where
	--			I.FacilityId = O.FacilityID and I.FacilityId = 686   and
	--			O.BioMetric=1 and
	--			datediff(day,RecordDate,getdate()) <=10 ;
		

	--	select * from @t where userID not in (select userID from @t1);

	-- end
	
		
END

