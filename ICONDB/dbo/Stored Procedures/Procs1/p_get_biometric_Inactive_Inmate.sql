-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_biometric_Inactive_Inmate]
	@facilityID int OUTPUT,
	@PIN	varchar(12) OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET @facilityID =0;
	SET @PIN ='';
	SELECT top 1 @facilityID=I.FacilityID,@PIN= I.PIN  from 
			[leg_Icon].[dbo].tblInmate I with(nolock) ,  [leg_Icon].[dbo].tblFacilityOption O with(nolock)  where
			I.FacilityId = O.FacilityID and
			I.BioRegister =1 and 
			I.Status >1 and
			O.BioMetric=1
    

	if(@facilityID >0 and  @PIN <> '')
	 begin
		update tblInmate set BioRegister= 0 where FacilityId= @facilityID and PIN=@PIN;
		return 0;
	 end
	
END

