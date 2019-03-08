-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[p_get_Washoe_onetime_Fix]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int, PrimaryLanguage int);
	
	insert @t
	SELECT  I.FacilityID, I.InmateID, I.PIN, 
	 Case when (I.PrimaryLanguage < 2 and I.facilityID in (1, 558, 670, 686, 691, 701, 747, 781, 782)) 
	 then (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) else (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.InmateID) end  UserID, 
	I.Status, I.PrimaryLanguage from
			[Leg_ICON].[dbo].tblInmate I with(nolock), [Leg_ICON].[dbo].tblFacilityOption O with(nolock)  where
			I.FacilityId = O.FacilityID and
			I.BioRegister =1 and 
			I.Status >0 and
			O.BioMetric=1 
			and I.facilityId = 851
			and (( inmateId % 2 ) <> 0);
    if(@@ROWCOUNT >0)
		select * from @t 
		--where facilityID = 670
		; 
END


