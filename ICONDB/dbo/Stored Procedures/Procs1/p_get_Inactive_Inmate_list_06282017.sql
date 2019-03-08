-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Inactive_Inmate_list_06282017]
AS
BEGIN
	Declare @t table (facilityID int, InmateID varchar(12), PIN varchar(12), UserID varchar(17), Status int, PrimaryLanguage int);
	--Declare @t1 table (facilityID int,UserID varchar(17));
	insert @t
	SELECT  I.FacilityID, I.InmateID, I.PIN, 
	 Case when (I.PrimaryLanguage < 2 and I.facilityID in (1, 558, 670, 686, 691, 701, 747, 781, 782)) 
	 then (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) else (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.InmateID) end  UserID, 
	I.Status, I.PrimaryLanguage from
			[leg_Icon].[dbo].tblInmate I with(nolock) ,  [leg_Icon].[dbo].tblFacilityOption O with(nolock)  where
			I.FacilityId = O.FacilityID and
			I.BioRegister =1 and 
			I.Status >1 and
			O.BioMetric=1 ;
    if(@@ROWCOUNT >0)
		select * from @t 
		--where facilityID = 670
		; 
END
