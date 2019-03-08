
CREATE FUNCTION dbo.fn_CalculatePif
 (@CLEC_calltype  char(2), @fromState varchar(2), @facilityID int)
RETURNS   Numeric(5,2) AS  
BEGIN 
	Declare @SurchargeID  varchar(5) , @Pif numeric(4,2)
	SET @Pif	= 0
	
	Select @SurchargeID  = SurchargeID from tblFacility with(nolock) where FacilityID =  @FacilityID


	if(@CLEC_calltype ='ST' ) 
		Select @Pif = CASE   WHEN PIFInterStPerLimitCharge >0 THEN  PIFInterStPerLimitCharge  * PIFInterStPerMinCharge ELSE PIFInterStPerCallCharge  END
		
		
					FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID  and  (state = 'ST'  Or State ='1')
	Else If (@CLEC_calltype ='RL' )
		
		Select @Pif = CASE   WHEN PIFInterLaPerLimitCharge >0 THEN  PIFInterLaPerLimitCharge  * PIFInterLaPerMinCharge ELSE PIFInterLaPerCallCharge  END 
		
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  @fromState)
	Else If (@CLEC_calltype ='AL'  Or @CLEC_calltype='LC')
		Select @Pif = CASE   WHEN PIFIntraLaPerLimitCharge >0 THEN  PIFIntraLaPerLimitCharge  * PIFIntraLaPerMinCharge ELSE PIFIntraLaPerCallCharge  END 
		
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  @fromState)
	
	
	ELSE
		Select @Pif =   PIFIntlPerCallcharge 		
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  @fromState) 



	return @Pif


END













