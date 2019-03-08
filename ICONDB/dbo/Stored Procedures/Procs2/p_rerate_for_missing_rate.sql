
CREATE PROCEDURE [dbo].[p_rerate_for_missing_rate] 

AS

Declare  @RecordID bigint,    @facilityID int, @tono varchar(18) , @fromNo  char(10)  , @billtype char(2) , @SettlementCode	 char(1) , @callRevenue  numeric(6,2) ,@callduration int

declare @firstMinute   numeric(6,4),@nextMinute   numeric(6,4) ,@connectFee numeric(6,4)  ,@duration 	smallint ,@CLEC_callType   char(2) , 
@indicator19	char(1) ,@fromState	char(2),@fromCity	varchar(10),@toState	char(2) ,@toCity		varchar(10) ,
@fromLata	varchar(3) ,@toLata	varchar(3) ,@libCode	varchar(2),
@ratePlanID	varchar(7)  ,@PIP	Numeric(6,4), @Increment	tinyint

select top 1  @RecordID =RecordID  ,  @facilityID= FacilityID, @fromNo = fromno, @tono = tono,@billtype = billtype, @callduration = duration   from tblcallsbilled   WHERE
	  ( billtype ='10'  Or  billtype ='03'  Or billtype ='05'  or billtype ='01'  )  and   datediff(hh,recorddate,getdate()) < 24  and 
		CallRevenue =0



EXEC p_Recalculate_Rate_Surcharge  @fromNo , @tono , '',  @facilityID ,@billtype,'0','',
		@firstMinute   OUTPUT,@nextMinute    OUTPUT,@connectFee   OUTPUT,@duration 	OUTPUT,@CLEC_callType    OUTPUT,
		@indicator19	 OUTPUT,@fromState	OUTPUT,@fromCity	 OUTPUT,@toState	 OUTPUT,@toCity		 OUTPUT,
		@fromLata	 OUTPUT,@toLata	 OUTPUT,@libCode	 OUTPUT,@ratePlanID	 OUTPUT,@PIP		 OUTPUT, @Increment		OUTPUT

EXEC  p_determine_setlementCode  @fromState	,@toState	,@fromLata	,@tolata	, @SettlementCode	 Output 

SET @callRevenue = dbo.fn_CalculateCallRevenue(@firstMinute  ,@nextMinute ,@connectFee ,@callduration ,@CLEC_callType  ,@PIP  ,@duration ) 

select @RecordID

IF (@connectFee > 0)
	Update   tblcallsbilled  SET  CallType  =@CLEC_callType ,
				    FromState= @fromState,
				     FromCity =@fromCity	,
				    ToState = @toState,
				    ToCity   = @toCity,
				   LibraryCode = @libCode,
				    Indicator19 = @indicator19	,
				   SettlementCode=@SettlementCode,
				   complete  = 1,
				   ratePlanID =@ratePlanID,
				   firstMinute =@firstMinute ,
				   nextMinute = @nextMinute ,
				   connectFee = @connectFee,
				   minDuration =@duration,
				  TotalSurcharge = @PIP,
				   MinIncrement = @Increment, 
				  CallRevenue  =@callRevenue
				  Where RecordID = @RecordID and tono = @tono

If ( @billtype ='10')
	Update tblprepaid set balance = balance- @callRevenue, ModifyDate  = getdate()  where phoneno = @tono

