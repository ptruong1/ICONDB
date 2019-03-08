CREATE PROCEDURE [dbo].[p_insert_billed_calls_from_LiveOp]
@callDate	varchar(6),
@connectTime	varchar(6),
@FacilityID	int,
@AgentID	int,
@fromNo	varchar(10),
@toNo		varchar(18),
@fromState	varchar(2),
@fromCity	varchar(10),
@toState	varchar(2),
@toCity		varchar(10),
@creditCardType	varchar(1),
@creditCardNo		varchar(20),   
@creditCardExp		varchar(4),
@zipcode		varchar(10),
@cvv			varchar(4),
@BillType	varchar(2) , 
@callType	varchar(2), 
@errorCode		tinyint,
@firstMinute		numeric(6,4),
@addMinute		numeric(6,4),
@connectFee		numeric(6,4),
@Surcharge		numeric(6,4),
@MinDuration		smallint,
@ratePlanID		varchar(7),
@responseCode		char(3),
@increment		tinyint,
@inmateID		varchar(12),
@PIN			varchar(12),
@duration		int
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) , @callRevenue numeric(6,2), @billtoNo char(10);
Declare  @Pif	numeric(4,2)  , @NSF numeric(4,2)   ,@PSC	numeric(4,2)   ,@NIF numeric(4,2) ,@BDF numeric(4,2)  ,@RAF 	numeric(4,2)  ,@BSF numeric(4,2)  ,@MaxCallTime int ;
Declare  @totalSurcharge  numeric(4,2)  ,@Fee2  numeric(4,2)   ,@Fee3  numeric(4,2) , @SChannel varchar(3), @status char (1) , @timeZone tinyint, @recordDate datetime, @settlementCode	char(1) ,@RateClass char(1);
Declare @countryCode varchar(4) , @phone varchar(10), @RejErrorcode tinyint, @UsedBy varchar(20),@RecordID bigint,@RecordFileName varchar(16), @userName varchar(16),@folderDate		varchar(8);
SET @RateClass ='6';
SET @trunKID = '';
SET @YY = right(@callDate,2);
SET @MM=Left(@callDate,2);
SET @Pif = 0;
SET  @NSF =0 ;
SET  @PSC = 0;
SET  @NIF = 0;
SET  @BDF = 0;
SET  @RAF = 0;
SET  @BSF = 0;
SET  @Fee2 =0;
SET  @Fee3 =0;
SET @callRevenue  =0;
SET @MaxCallTime  =1;
SET @RejErrorcode = @errorCode;

if(@responseCode ='011')
	SET @BillType='10';
	
IF( datepart(dw ,getdate()) = 1 OR datepart(dw ,getdate()) = 7 )   
	SET @callPeriod = '3';
ELSE
  Begin
	SET  @HH = CAST( Left(@connectTime,2 ) AS smallint);
	If( @HH >6 and @HH < 18 )  
		SET  @callPeriod = '1';
	ELSE IF (@HH >18  and  @HH < 22) 
		SET @callPeriod = '2';
	ELSE   
		SET @callPeriod = '3';
  End
if(@inmateID='' or isnumeric(@inmateID)=0) 
 begin
	SET @inmateID='0';
 end

if(@PIN='' or isnumeric(@PIN)=0 ) 
	SET @PIN='0';
Set @settlementCode =  dbo.[fn_determine_setlementCode]( @fromState,@toState,'0','0') ;

if(@creditcardno<>'' and @billtype='01') SET  @billtype='05';

If ( @BillType in ( '08','13'))
 Begin
	SET @fromstate='';
	SET @fromCity ='';
	SET @toState='';
	SET @toCity ='';
	SET @firstMinute =0;
	SET @addMinute =0;
	SET @connectFee =0;
	SET @callType ='NA';
	SET @Surcharge	=0;
 End
Else 
 Begin
	IF (@BillType = '01' )  	SET  @billToNo = @toNo;
  End


if(ltrim(@PIN) ='')
begin
  	SET @PIN ='0';
	SET @InmateID ='0';
end
if(@inmateID <>'0')
	SET @UsedBy = @inmateID;
Else
	SET @UsedBy = @tono;
	
Select @RecordID = recordID,@userName=userName,@folderDate=folderDate, @FacilityID = FacilityID   from tblOncalls with(nolock) where FromNo = @fromNo and billType ='06' and duration is null order by recordID ;
update tblOncalls set duration = @duration, lastModify =@recordDate  where  RecordID = @RecordID;

set @RecordFileName = CAST ( @RecordID as varchar(12)) + '.WAV';

select  @timeZone  = isnull(timezone,0) from tblfacility with(nolock)  where facilityID = @facilityID ;
Set  @recordDate = getdate();
set @recordDate = dateadd(hh, @timeZone, @recordDate) ;
if (@duration >1) 
 begin	
	SET @callRevenue = dbo.fn_CalculateCallRevenue(@firstMinute  ,@addMinute ,@connectFee ,@duration ,@callType  ,@Surcharge  ,@minDuration ) ;	
		
	 
	If(@Surcharge > 0 )
		Begin
			EXEC p_get_surcharge_detail @FacilityID ,@calltype ,@fromState	,@Pif	   OUTPUT , @NSF    OUTPUT ,@PSC	  OUTPUT ,@NIF  OUTPUT , @BDF  OUTPUT ,@RAF   OUTPUT , @BSF   OUTPUT ,@Fee2   OUTPUT,@Fee3  OUTPUT ;
		End
	 INSERT INTO  tblCallsbilled( RecordID,Calldate, ConnectTime, FromNo ,   ToNo, BillToNo , MethodOfRecord ,billType,callType, FromState, FromCity , 
		ToState, ToCity, CallPeriod,  CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,CreditCardZip,settlementCode,
	 	userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,ResponseCode,
		AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID,duration, CallRevenue, PIF)
	 Values(@recordID,@Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,'04', @billType,@callType, @FromState, @FromCity ,  
		@ToState, @ToCity,  @CallPeriod,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,@zipcode, @settlementCode,
		@UserName,@RejErrorcode, @RateClass, @firstMinute,@addMinute,@connectFee,@Surcharge,@MinDuration,@recordDate,@ratePlanID,@ResponseCode,
		 @AgentID,@RecordFileName,@increment, '0',@folderDate	,@inmateID ,@PIN, @facilityID, @duration, @CallRevenue,@Pif );

	If(@billtype = '07' ) -- pdate Debit balance
	 Begin
	 	Update tbldebit SET balance = balance - @CallRevenue, modifydate = getdate(),userName=@UsedBy, status=1 where AccountNo = @creditCardNo	;	
	 End	
	Else If(@billtype = '10')  -- Update balance
	 begin
	  
			If(left(@toNo,3) <>  '011')
			 Begin
				Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName =@UsedBy, status=1 where PhoneNo =@toNo	;
				
			End
			Else
			 Begin
				
				Set  @countryCode = dbo.fn_determine_countryCode (@tono ) ;
				SET @phone = Substring(@tono, 4+ len(@countryCode) , len(@tono));
				Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName ='Enduser',  status=1 where PhoneNo =@phone and Countrycode = @countryCode;
				
			 End

	  end
	  
	 
End	
If(@errorCode > 0 or @duration =0)
 Begin
		EXEC  p_insert_unbilled_calls4  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, '',@creditCardNo,  @RecordDate,@callType, @RecordID ;
	
 end
if(@PIN <> '0' )
 begin
	Delete tblinmateOncall where   pin =@PIN  and facilityID = @FacilityID;
	EXEC [dbo].[p_auto_insert_PAN] 		@facilityID ,@inmateID ,		@PIN ,	@ToNo;
 end
return @@error;
