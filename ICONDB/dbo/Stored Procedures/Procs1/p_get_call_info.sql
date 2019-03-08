

CREATE PROCEDURE [dbo].[p_get_call_info]
@ANI  varchar(10),
@DNI	varchar(20),
@trunk  varchar(6),
@billType char(2),
@firstMinute   numeric(4,2)  OUTPUT,
@nextMinute   numeric(4,2)  OUTPUT,
@connectFee numeric(4,2)  OUTPUT,
@duration 	smallint OUTPUT,
@CLEC_callType   char(2)  OUTPUT,
@indicator19	char(1)  OUTPUT,
@toState	char(2) OUTPUT,
@toCity		varchar(20) OUTPUT,
@fromLata	varchar(3) OUTPUT,
@ToLata	varchar(3) OUTPUT,
@LibCode	varchar(2) OUTPUT,
@RatePlanID	varchar(4)  OUTPUT,
@Pif		Numeric(4,2) OUTPUT,
@Increment	tinyint	OUTPUT    
 AS
Declare		@fromState	char(2) ,  @fromCity	varchar(20),  @i int
SET @toCity =''
SET @toState	=''
SET @indicator19 ='0'
SET  @ToLata = '000'
SET @Pif =0
SET @Increment =1


EXEC  @i = p_calculate_mileage_live
			@ANI ,
			@DNI	,
			@trunk ,
			@billType ,
			@firstMinute    OUTPUT,
			@nextMinute  OUTPUT,
			@connectFee  OUTPUT,
			@duration        OUTPUT,
			@CLEC_callType  OUTPUT,
			@indicator19	OUTPUT,
			@fromState	 OUTPUT,
			@fromCity	 OUTPUT,
			@toState	 OUTPUT,
			@toCity		 OUTPUT,
			@fromLata	 OUTPUT,
			@toLata	 OUTPUT,
			@libCode	OUTPUT,
			@ratePlanID	 OUTPUT,
			@Pif		 OUTPUT,
			@Increment	OUTPUT

Return @i

