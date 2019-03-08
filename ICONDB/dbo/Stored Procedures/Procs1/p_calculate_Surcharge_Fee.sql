

CREATE PROCEDURE [dbo].[p_calculate_Surcharge_Fee]
@SurchargeID	varchar(5),
@CLEC_calltype char(2),
@fromState	char(2),
@TotalSurcharges	numeric(4,2)   Output,
@LibraryCode    char(2)   OUTPUT

 AS
SET NOCOUNT ON
declare @Pif	numeric(4,2)  , @NSF numeric(4,2) ,@PSC	numeric(4,2) ,@NIF numeric(4,2)  ,@BDF numeric(4,2)  ,@RAF 	numeric(4,2)   ,  @BSF numeric(4,2) ,
	@Fee2  numeric(4,2)  , @Fee3  numeric(4,2) ,@Fee4   numeric(4,2) ,@Fee5 numeric(4,2)

SET @Pif  =0
SET  @NSF =0
SET @PSC = 0
SET @NIF =0
SET @BDF = 0
SET @RAF=0
SET @BSF =0
SET @TotalSurcharges = 0


	
		
if(@CLEC_calltype ='ST'  )
  
	Select @Pif = CASE   WHEN PIFInterStPerLimitCharge >0 THEN  PIFInterStPerLimitCharge  * PIFInterStPerMinCharge ELSE PIFInterStPerCallCharge  END ,
	@NSF = NSFInterStPerCallCharge  ,  @PSC =PSCInterStPerCallCharge , @NIF =  NIFInterStPerCallCharge,  
	@BDF =  BDFInterStPerCallCharge , @RAF = A4250InterStPerCallCharge,  @BSF =  Fee1InterStPerCallCharge , @Fee2 =  Fee2InterStPerCallCharge
				FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID =@SurchargeID	and  (state = 'ST'  or  state ='1')
  
Else If (@CLEC_calltype ='RL')
	
	Select @Pif = CASE   WHEN PIFInterLaPerLimitCharge >0 THEN  PIFInterLaPerLimitCharge  * PIFInterLaPerMinCharge ELSE PIFInterLaPerCallCharge  END ,
	@NSF = NSFInterLaPerCallCharge  ,  @PSC =PSCInterLaPerCallCharge , @NIF =  NIFInterLaPerCallCharge, 
	 @BDF =  BDFInterLaPerCallCharge , @RAF = A4250InterLaPerCallCharge , @BSF = Fee1InterLaPerCallCharge , @Fee2 =  Fee2InterLaPerCallCharge
			FROM tblSurchargeDetail  WITH(NOLOCK)  	WHERE SurchargeID =@SurchargeID  and state =  @fromState
Else If (@CLEC_calltype ='AL'  or @CLEC_calltype ='LC' )
 
	Select @Pif = CASE   WHEN PIFIntraLaPerLimitCharge >0 THEN  PIFIntraLaPerLimitCharge  * PIFIntraLaPerMinCharge ELSE PIFIntraLaPerCallCharge  END ,
	@NSF = NSFIntraLaPerCallCharge  ,  @PSC =PSCIntraLaPerCallCharge , @NIF =  NIFIntraLaPerCallCharge,  
	@BDF =  BDFIntraLaPerCallCharge , @RAF = A4250IntraLaPerCallCharge, @BSF =  Fee1IntraLaPerCallCharge  , @Fee2 =  Fee2IntraLaPerCallCharge
			FROM tblSurchargeDetail  WITH(NOLOCK)  	WHERE SurchargeID =@SurchargeID  and state =  @fromState
Else If (@CLEC_calltype ='PU')
 
	Select @Pif = CASE   WHEN PIFIntraLaPerLimitCharge >0 THEN  PIFIntraLaPerLimitCharge  * PIFIntraLaPerMinCharge ELSE PIFIntraLaPerCallCharge  END ,
	@NSF = NSFIntraLaPerCallCharge  ,  @PSC =PSCIntraLaPerCallCharge , @NIF =  NIFIntraLaPerCallCharge, 
	@BDF =  BDFIntraLaPerCallCharge , @RAF = A4250IntraLaPerCallCharge, @BSF =  Fee1IntraLaPerCallCharge  , @Fee2 =  Fee2IntraLaPerCallCharge
			FROM tblSurchargeDetail  WITH(NOLOCK)  	WHERE SurchargeID =@SurchargeID  and state =  'PU'
	
Else if(@CLEC_calltype ='CA'  )
	Select @Pif = CASE   WHEN PIFIntraLaPerLimitCharge >0 THEN  PIFIntraLaPerLimitCharge  * PIFIntraLaPerMinCharge ELSE PIFIntraLaPerCallCharge  END ,
	@NSF = NSFIntraLaPerCallCharge  ,  @PSC =PSCIntraLaPerCallCharge , @NIF =  NIFIntraLaPerCallCharge,
	@BDF =  BDFIntraLaPerCallCharge , @RAF = A4250IntraLaPerCallCharge, @BSF =  Fee1IntraLaPerCallCharge  , @Fee2 =  Fee2IntraLaPerCallCharge
			FROM tblSurchargeDetail  WITH(NOLOCK)  	WHERE SurchargeID =@SurchargeID  and state =  '2'
		
	
ELSE
	Select @Pif =   PIFIntlPerCallcharge , 	@NSF = NSFIntlPerCallCharge  ,  @PSC =PSCIntlPerCallCharge , 
	 @NIF =  NIFIntlPerCallCharge, @BDF =  BDFIntlPerCallCharge , @RAF = A4250IntlPerCallCharge , @BSF = Fee1IntlPerCallCharge , @Fee2 =  Fee2IntlPerCallCharge
			FROM tblSurchargeDetail  WITH(NOLOCK) 	WHERE SurchargeID =@SurchargeID  and (state =  'ST') 



	
	




If(  @fromState =  'FL'   Or   @fromState =  'CT'   Or   @fromState =  'CO'   Or @fromState =  'IL'   or  @fromState =  'TN'  Or  @fromState =  'PA'  Or  @fromState =  'TX'   )

	SET @TotalSurcharges	 = Isnull(@Pif,0)	+ Isnull(  @NSF,0) + Isnull( @PSC,0) + Isnull(@NIF,0) +  Isnull(@BDF,0)   +  Isnull( @Fee2 ,0) 
else
	SET @TotalSurcharges	 =  Isnull(@Pif,0)+  Isnull( @NSF,0) +  Isnull(@PSC,0) + Isnull( @NIF,0) + Isnull( @BDF,0)   +  Isnull( @Fee2 ,0) +   Isnull(@RAF,0) + Isnull(@BSF,0)

If (@LibraryCode = ''  Or  @LibraryCode  is Null)    SET @LibraryCode = 'TQ'

