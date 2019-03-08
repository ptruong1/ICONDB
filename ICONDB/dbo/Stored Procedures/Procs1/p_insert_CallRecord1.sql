

CREATE PROCEDURE [dbo].[p_insert_CallRecord1]
@callDate	varchar(6),
@connectTime	varchar(6),
@MethodOfRecord  varchar(2),
@fromNo	varchar(10),
@toNo		varchar(18),
@billToNo	varchar(10),
@fromState	varchar(2),
@fromCity	varchar(10),
@toState	varchar(2),
@toCity		varchar(10),
@creditCardType	varchar(10),
@creditCardNo		varchar(20),
@creditCardExp		varchar(4),
@libraryCode	varchar(2),
@BillType	varchar(2) , -- 00 calling card, 01 collect, 02 third party, 03 credit card , 
@callType	varchar(2),  -- calltype such as ST, RL, DA
@indicator19		char(1),
@settlementCode	char(1),
@projectCode		varchar(6),
@userName		varchar(23),
@errorCode		varchar(3),
@RateClass		char(1),
@firstMinute		numeric(4,2),
@addMinute		numeric(4,2),
@connectFee		numeric(4,2),
@pip			numeric(4,2),
@MinDuration		smallint,
@ratePlanID		varchar(7),
@fromLata		varchar(3),
@toLata		varchar(3),
@Dberror		char(1),
@responseCode		char(3),
@zipcode		varchar(10),
@cvv			varchar(4),
@authName		varchar(50),
@AgentID		varchar(7),
@increment		tinyint
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500), @RecordID varchar(8), @callPeriod  char(1), @HH smallint, @trunKID varchar(4)
Declare  @Pif	numeric(4,2)  , @NSF numeric(4,2)   ,@PSC	numeric(4,2)   ,@NIF numeric(4,2) ,@BDF numeric(4,2)  ,@RAF 	numeric(4,2)  ,@BSF numeric(4,2)   
Declare  @totalSurcharge  numeric(4,2)  ,@Fee2  numeric(4,2)   ,@Fee3  numeric(4,2) , @facilityID int
SET @trunKID = ''
SET @YY = right(@callDate,2)
SET @MM=Left(@callDate,2)
SET @Pif = 0
SET  @NSF =0 
SET  @PSC = 0
SET  @NIF = 0
SET  @BDF = 0
SET  @RAF = 0
SET  @BSF = 0
SET  @Fee2 =0
SET  @Fee3 =0

IF( datepart(dw ,getdate()) = 1 OR datepart(dw ,getdate()) = 7 )   
	SET @callPeriod = '3'
ELSE
  Begin
	SET  @HH = CAST( Left(@connectTime,2 ) AS smallint)
	If( @HH >6 AND @HH < 18 )  
		SET  @callPeriod = '1'
	ELSE IF (@HH >18  and  @HH < 22) 
		SET @callPeriod = '2'
	ELSE   
		SET @callPeriod = '3'
  End


IF  (LEFT(@toNo,3) = '011'  Or  @calltype = 'IN')
	SET  @SettlementCode  = 'N'
ELSE
	EXEC  p_determine_setlementCode  @fromState	,@toState	,@fromLata	,@tolata	, @SettlementCode	 Output

If(@responseCode = '800' ) 
	 SET @BillType ='12'
Else If (CAST(@responseCode as int) <100  and @billtype <>'07'  )
 Begin
	select @facilityID = facilityID from tblcalls with(nolock) where projectcode = @projectcode and calldate = @calldate
	EXEC p_get_surcharge_detail 	@FacilityID	,@callType ,@fromState	,
		@Pif	 OUTPUT , @NSF    OUTPUT ,@PSC	   OUTPUT ,@NIF    OUTPUT ,	@BDF    OUTPUT ,@RAF    OUTPUT , 	@BSF   OUTPUT ,@Fee2      OUTPUT, @Fee3 OUTPUT
	SEt @totalSurcharge =isnull(@Pif,0) + isnull(@NSF,0) + isnull(@PSC,0) + isnull(@NIF,0) + isnull(@BDF,0) +  isnull(@RAF,0) +  isnull(@BSF,0) + isnull(@Fee2,0)  + isnull(@Fee3,0)
	
	If @pip < @totalSurcharge  SET  @pip =  @totalSurcharge
  End


 INSERT INTO  tblCallsLive( Calldate, ConnectTime, FromNo ,   ToNo, BillToNo ,  MethodOfRecord,billType,callType, FromState, FromCity ,  
	ToState, ToCity, CreditCardType, CreditCardNo , CreditCardExp,CallPeriod,LibraryCode, Indicator19, SettlementCode,CreditCardZip, CreditCardCVV, authName,
 	ProjectCode ,userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurCharge,MinDuration,recordDate,ratePlanID,DbError,ResponseCode,
	Pif,NSF,PSC,NIF,BDf, RAF, BSF, Fee2, Fee3 ,AgentID, RecordFile, MinIncrement)
 Values( @Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,  @MethodOfRecord,@billType,@callType, @FromState, @FromCity , 
	@ToState, @ToCity, @CreditCardType, @CreditCardNo,@CreditCardExp , @CallPeriod,@LibraryCode, @Indicator19, @SettlementCode,  @zipcode, @cvv,@authName,
	@ProjectCode ,@UserName,@errorCode, @RateClass, @firstMinute,@addMinute,@connectFee,@Pip,@MinDuration,getDate(),@ratePlanID,@DbError, @ResponseCode,
	@Pif, @NSF  ,	@PSC	,@NIF   ,@BDF    ,@RAF 	,@BSF  , @Fee2, @Fee3 , @AgentID, '',@increment)

