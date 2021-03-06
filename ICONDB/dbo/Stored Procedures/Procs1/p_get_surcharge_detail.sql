﻿

CREATE PROCEDURE [dbo].[p_get_surcharge_detail]
@FacilityID int,
@CLEC_calltype char(2),
@fromState	char(2),
@Pif	numeric(4,2)    OUTPUT ,
 @NSF numeric(4,2)   OUTPUT ,
@PSC	numeric(4,2)   OUTPUT ,
@NIF numeric(4,2)  OUTPUT ,
@BDF numeric(4,2)  OUTPUT ,
@RAF 	numeric(4,2)   OUTPUT , 
@BSF numeric(4,2)    OUTPUT ,
@Fee2  numeric(4,2)    OUTPUT,
@Fee3	  numeric(4,2)    OUTPUT

 AS


SET NOCOUNT ON
Declare @SurchargeID  varchar(5)
SET @Pif	= 0
SET @NSF = 0
SET @PSC	= 0
SET @NIF = 0
SET @BDF= 0
SET @RAF 	= 0
SET @BSF = 0
SET @Fee2 = 0
Set   @Fee3 =0
Select @SurchargeID  = SurchargeID from tblFacility with(nolock) where FacilityID =  @FacilityID
  Begin

	if(@CLEC_calltype ='ST' ) 
		Select @Pif = CASE   WHEN PIFInterStPerLimitCharge >0 THEN  PIFInterStPerLimitCharge  * PIFInterStPerMinCharge ELSE PIFInterStPerCallCharge  END ,
		@NSF = NSFInterStPerCallCharge  ,  @PSC =PSCInterStPerCallCharge , @NIF =  NIFInterStPerCallCharge, 
		@BDF =  BDFInterStPerCallCharge , @RAF = A4250InterStPerCallCharge,  @BSF =  Fee1InterStPerCallCharge ,  @Fee2 = Fee2InterStPerCallCharge 
					FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID  and  (state = 'ST'  Or State ='1')
	Else If (@CLEC_calltype ='RL' )
		
		Select @Pif = CASE   WHEN PIFInterLaPerLimitCharge >0 THEN  PIFInterLaPerLimitCharge  * PIFInterLaPerMinCharge ELSE PIFInterLaPerCallCharge  END ,
		@NSF = NSFInterLaPerCallCharge  ,  @PSC =PSCInterLaPerCallCharge , @NIF =  NIFInterLaPerCallCharge,
		 @BDF =  BDFInterLaPerCallCharge , @RAF = A4250InterLaPerCallCharge , @BSF = Fee1InterLaPerCallCharge ,  @Fee2 =   Fee2InterLaPerCallCharge 
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  @fromState)
	Else If (@CLEC_calltype ='AL'  Or @CLEC_calltype='LC')
		Select @Pif = CASE   WHEN PIFIntraLaPerLimitCharge >0 THEN  PIFIntraLaPerLimitCharge  * PIFIntraLaPerMinCharge ELSE PIFIntraLaPerCallCharge  END ,
		@NSF = NSFIntraLaPerCallCharge  ,  @PSC =PSCIntraLaPerCallCharge , @NIF =  NIFIntraLaPerCallCharge, 
		@BDF =  BDFIntraLaPerCallCharge , @RAF = A4250IntraLaPerCallCharge, @BSF =  Fee1IntraLaPerCallCharge , @Fee2 =  Fee2IntraLaPerCallCharge 
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  @fromState)
	Else If (@CLEC_calltype ='PU')
		Select @Pif = CASE   WHEN PIFIntraLaPerLimitCharge >0 THEN  PIFIntraLaPerLimitCharge  * PIFIntraLaPerMinCharge ELSE PIFIntraLaPerCallCharge  END ,
		@NSF = NSFIntraLaPerCallCharge  ,  @PSC =PSCIntraLaPerCallCharge , @NIF =  NIFIntraLaPerCallCharge, 
		@BDF =  BDFIntraLaPerCallCharge , @RAF = A4250IntraLaPerCallCharge, @BSF =  Fee1IntraLaPerCallCharge , @Fee2 =  Fee2IntraLaPerCallCharge 
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  'PU')
	Else If   (@CLEC_calltype ='CA')    Return 
	ELSE
		Select @Pif =   PIFIntlPerCallcharge , 	@NSF = NSFIntlPerCallCharge  ,  @PSC =PSCIntlPerCallCharge ,
		 @NIF =  NIFIntlPerCallCharge, @BDF =  BDFIntlPerCallCharge , @RAF = A4250IntlPerCallCharge , @BSF = Fee1IntlPerCallCharge , @Fee2 =  Fee2IntlPerCallCharge
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID = @SurchargeID   and (state =  @fromState) 
  end

