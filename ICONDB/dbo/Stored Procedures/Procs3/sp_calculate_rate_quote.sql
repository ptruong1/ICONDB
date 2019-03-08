
CREATE PROCEDURE [dbo].[sp_calculate_rate_quote]
@ANI  varchar(10),
@DNI	varchar(20),
@trunk  varchar(6),
@fromState	char(2) OUTPUT,
@fromCity	varchar(20) OUTPUT,
@toState	char(2) OUTPUT,
@toCity		varchar(20) OUTPUT,
@libCode	varchar(2) OUTPUT,
@CLEC_callType   char(2)  OUTPUT,
@ratePlanID	varchar(4)  OUTPUT,
@Mileage	int  OUTPUT,
@duration smallint OUTPUT,
@CallingCardfirstMinute   numeric(4,2)  OUTPUT,  -- Calling Card
@CreditCardfirstMinute   numeric(4,2)  OUTPUT,    --Credit Card
@CollectCallfirstMinute   numeric(4,2)  OUTPUT,    --Collect Call
@ThirdPartyfirstMinute   numeric(4,2)  OUTPUT,    --Third party Call
@nextMinute   numeric(4,2)  OUTPUT   

 AS

SET NOCOUNT ON
Declare  @ANI_NPA char(3), @ANI_NXX char(3), @dayCode char(2), @MinuteDuration smallint, @MinuteDurationInt  smallint, @ANI_lata  char(3), @DNI_lata char(3), @lataType char(1)
Declare   @DNI_NPA char(3), @DNI_NXX char(3),  @ANI_pointID char(1),  @DNI_pointID char(1),@pointID varchar(2)
Declare   @ANI_Horizontal   numeric(8,2), @ANI_vertical  numeric(8,2),  @DNI_Horizontal   numeric(8,2), @DNI_vertical  numeric(8,2) 
Declare  @IntCall  int, @countryCode  varchar(4), @configID varchar(4) ,@authcode  varchar(10), @PromptLang	tinyint , @isGU  tinyint, @stateFeeOpt  bit
Declare  @CLconnectFee numeric(4,2) ,  @CCconnectFee numeric(4,2) ,  @COconnectFee numeric(4,2) , @THconnectFee numeric(4,2)
Declare   @fromLata  varchar(3)  , @toLata  varchar(3) , @pif  numeric(4,2), @firstMinute   numeric(4,2)  , @connectFee numeric(4,2),  @TotalSurcharge numeric(4,2) ,@indicator19	char(1) , @increment tinyint
SET @fromState =''
SET @fromCity	=''
SET @toState	=''
SET @toCity	=''
SET @fromLata	=''
SET @toLata	=''
SET @firstMinute   =0
SET @nextMinute   =0
SET @duration = 0
SET @MinuteDuration = 1
SET @MinuteDurationInt  = 1
SET  @IntCall  = 0
SET @ANI_NPA  =LEFT(@ANI,3)
SET  @ANI_NXX = SUBSTRING(@ANI,4,3)
SET @libCode =''
SET @ratePlanID = ''
SET  @trunk = ltrim( rtrim(@trunk))
SET @DNI = ltrim(rtrim(@DNI))
SET @DNI_NPA = LEFT(@DNI,3) 
SET  @DNI_NXX = SUBSTRING(@DNI	,4,3)
SET  @pif =0
SET @CallingCardfirstMinute  =0
SET @CreditCardfirstMinute =0
SET @CollectCallfirstMinute  =0
SET @ThirdPartyfirstMinute   =0

SET	 @duration =0
SET 	@CLEC_callType  =''
SET	@indicator19	 =''
SET	@fromState	 =''
SET	@fromCity	 =''
SET	@toState	 =''
SET	@toCity		 =''
SET	@fromLata	 =''
SET	@toLata	 =''
SET	@libCode	 =''
SET	@ratePlanID	 =''
SET      @TotalSurcharge   =0

--calling card
EXEC p_calculate_mileage_live   @ANI ,  	@DNI	,	@trunk  ,	'00' ,
	@firstMinute     OUTPUT,@nextMinute    OUTPUT,@connectFee    OUTPUT,@duration   OUTPUT,	@CLEC_callType      OUTPUT,	@indicator19	   OUTPUT,
	@fromState	  OUTPUT,@fromCity	  OUTPUT,@toState	  OUTPUT,@toCity		 OUTPUT,	@fromLata	  OUTPUT,	@toLata	 OUTPUT,
	@libCode	  OUTPUT,	@ratePlanID	  OUTPUT,	@TotalSurcharge			 OUTPUT ,@increment OUTPUT

SET @CallingCardfirstMinute    =@firstMinute + (@duration -1)* @nextMinute + @TotalSurcharge+ @connectFee
--- Collect Call
SET	 @duration =0
SET 	@CLEC_callType  =''
SET	@indicator19	 =''
SET	@fromState	 =''
SET	@fromCity	 =''
SET	@toState	 =''
SET	@toCity		 =''
SET	@fromLata	 =''
SET	@toLata	 =''
SET	@libCode	 =''
SET	@ratePlanID	 =''
SET      @TotalSurcharge   =0


EXEC p_calculate_mileage_live   @ANI ,  	@DNI	,	@trunk  ,	'01' ,
	@firstMinute     OUTPUT,@nextMinute    OUTPUT,@connectFee    OUTPUT,@duration   OUTPUT,	@CLEC_callType      OUTPUT,	@indicator19	   OUTPUT,
	@fromState	  OUTPUT,@fromCity	  OUTPUT,@toState	  OUTPUT,@toCity		 OUTPUT,	@fromLata	  OUTPUT,	@toLata	 OUTPUT,
	@libCode	  OUTPUT,	@ratePlanID	  OUTPUT,	@TotalSurcharge			 OUTPUT, @increment OUTPUT



SET @CollectCallfirstMinute   = @firstMinute + (@duration -1)* @nextMinute + @TotalSurcharge+ @connectFee


--- ThridParty
SET	 @duration =0
SET 	@CLEC_callType  =''
SET	@indicator19	 =''
SET	@fromState	 =''
SET	@fromCity	 =''
SET	@toState	 =''
SET	@toCity		 =''
SET	@fromLata	 =''
SET	@toLata	 =''
SET	@libCode	 =''
SET	@ratePlanID	 =''
SET      @TotalSurcharge   =0


EXEC p_calculate_mileage_live   @ANI ,  	@DNI	,	@trunk  ,	'02' ,
	@firstMinute     OUTPUT,@nextMinute    OUTPUT,@connectFee    OUTPUT,@duration   OUTPUT,	@CLEC_callType      OUTPUT,	@indicator19	   OUTPUT,
	@fromState	  OUTPUT,@fromCity	  OUTPUT,@toState	  OUTPUT,@toCity		 OUTPUT,	@fromLata	  OUTPUT,	@toLata	 OUTPUT,
	@libCode	  OUTPUT,	@ratePlanID	  OUTPUT,	@TotalSurcharge			 OUTPUT ,@increment OUTPUT

SET @ThirdPartyfirstMinute    = @firstMinute + (@duration -1)* @nextMinute + @TotalSurcharge+ @connectFee

SET	 @duration =0
SET 	@CLEC_callType  =''
SET	@indicator19	 =''
SET	@fromState	 =''
SET	@fromCity	 =''
SET	@toState	 =''
SET	@toCity		 =''
SET	@fromLata	 =''
SET	@toLata	 =''
SET	@libCode	 =''
SET	@ratePlanID	 =''
SET      @TotalSurcharge   =0

EXEC p_calculate_mileage_live   @ANI ,  	@DNI	,	@trunk  ,	'03' ,
	@firstMinute     OUTPUT,@nextMinute    OUTPUT,@connectFee    OUTPUT,@duration   OUTPUT,	@CLEC_callType      OUTPUT,	@indicator19	   OUTPUT,
	@fromState	  OUTPUT,@fromCity	  OUTPUT,@toState	  OUTPUT,@toCity		 OUTPUT,	@fromLata	  OUTPUT,	@toLata	 OUTPUT,
	@libCode	  OUTPUT,	@ratePlanID	  OUTPUT,	@TotalSurcharge			 OUTPUT ,@increment OUTPUT

SET @CreditCardfirstMinute   = @firstMinute + (@duration -1)* @nextMinute + @TotalSurcharge+ @connectFee 

--SET @firstMinimunMinute =  @firstMinute + (@duration -1)* @nextMinute + @TotalSurcharge+ @connectFee

return @@error

