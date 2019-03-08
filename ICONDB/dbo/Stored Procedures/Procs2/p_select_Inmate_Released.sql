-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_Inmate_Released]

AS
BEGIN
	Declare @facilityID int, @PIN varchar(20) SET @facilityID =0; SET @PIN ='';
    SELECT top 1 I.FacilityID, I.InmateID, I.PIN, (Cast(I.FacilityID AS VARCHAR(4)) + '-' + I.PIN) as UserID, I.Status  
	from 
        [leg_Icon].[dbo].tblInmate I with(nolock), [leg_Icon].[dbo].tblFacilityOption O with(nolock)
		  where
                             I.FacilityId = O.FacilityID 
                                  and I.BioRegister =1 
                                  and  I.Status >1 
                                  and O.BioMetric=1
                                 

END

