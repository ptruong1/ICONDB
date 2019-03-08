CREATE PROCEDURE [dbo].[p_insert_billed_calls_webservice_test]
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
@userName		varchar(23),
@errorCode		tinyint,
@firstMinute		numeric(6,4),
@addMinute		numeric(6,4),
@connectFee		numeric(6,4),
@Surcharge		numeric(6,4),
@MinDuration		smallint,
@ratePlanID		varchar(7),
@responseCode		char(3),
@increment		tinyint,
@RecordFileName	varchar(20),
@channel		smallint,
@folderDate		varchar(8),
@inmateID		varchar(12),
@PIN			varchar(12),
@InRecordFile		varchar(12),
@RecordID		bigint,
@duration		int
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) , @callRevenue numeric(6,2), @billtoNo char(10);
Declare  @Pif	numeric(4,2)  , @NSF numeric(4,2)   ,@PSC	numeric(4,2)   ,@NIF numeric(4,2) ,@BDF numeric(4,2)  ,@RAF 	numeric(4,2)  ,@BSF numeric(4,2)  ,@MaxCallTime int ;
Declare  @totalSurcharge  numeric(4,2)  ,@Fee2  numeric(4,2)   ,@Fee3  numeric(4,2) , @SChannel varchar(3), @status char (1) , @timeZone tinyint, @recordDate datetime, @settlementCode	char(1) ,@RateClass char(1);
Declare @countryCode varchar(4) , @phone varchar(12), @RejErrorcode tinyint, @UsedBy varchar(20), @CurrentBalance numeric(7,2);
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
SET @CurrentBalance  =0;	
SET @duration = isnull(@duration,0);
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

select  @timeZone  = isnull(timezone,0) from tblfacility with(nolock)  where facilityID = @facilityID ;
Set  @recordDate = getdate();
set @recordDate = dateadd(hh, @timeZone, @recordDate) ;
if(ltrim(@PIN) ='')
begin
  	SET @PIN ='0';
	SET @InmateID ='0';
end
if(@inmateID <>'0')
	SET @UsedBy = @inmateID;
Else
	SET @UsedBy = @tono;
update tblOncalls set duration = @duration, lastModify =@recordDate, errorCode=@errorCode,  ResponseCode =@ResponseCode,  CreditCardType = @CreditCardType,   CreditCardNo = @CreditCardNo  ,     CreditCardExp =@CreditCardExp,   CreditCardZip= @zipcode , CreditCardCVV =@cvv, billtype=@billtype  where  RecordID = @RecordID;



if (@duration >1) 
 begin
	if(@facilityID >5)
	 begin
		Select @MaxCallTime=MaxCallTime*60 from tblfacility where facilityID=@facilityID;
		if(@duration > @MaxCallTime )
			SET @duration = @MaxCallTime ;
	 end
	--SET @callRevenue = dbo.fn_CalculateCallRevenue(@firstMinute  ,@addMinute ,@connectFee ,@duration ,@callType  ,@Surcharge  ,@minDuration ) ;	
	
	 SET @callRevenue = dbo.fn_CalculateCallRevenue_v2(@firstMinute  ,@addMinute ,@connectFee ,[dbo].[fn_calculateBillableTime](@duration,@minduration,@Increment) ,@callType  ,@Surcharge ) ;	
	
	--If(@Surcharge > 0 )
	--	Begin
	--		EXEC p_get_surcharge_detail @FacilityID ,@calltype ,@fromState	,@Pif	   OUTPUT , @NSF    OUTPUT ,@PSC	  OUTPUT ,@NIF  OUTPUT , @BDF  OUTPUT ,@RAF   OUTPUT , @BSF   OUTPUT ,@Fee2   OUTPUT,@Fee3  OUTPUT ;
	--	End
	-- INSERT INTO  tblCallsbilled( RecordID,Calldate, ConnectTime, FromNo ,   ToNo, BillToNo , MethodOfRecord ,billType,callType, FromState, FromCity , 
	--	ToState, ToCity, CallPeriod,  CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,CreditCardZip,settlementCode,
	-- 	userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,ResponseCode,
	--	AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID,duration, CallRevenue, PIF)
	-- Values(@recordID,@Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,'04', @billType,@callType, @FromState, @FromCity ,  
	--	@ToState, @ToCity,  @CallPeriod,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,@zipcode, @settlementCode,
	--	@UserName,@errorCode, @RateClass, @firstMinute,@addMinute,@connectFee,@Surcharge,@MinDuration,@recordDate,@ratePlanID,@ResponseCode,
	--	 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID,@PIN, @facilityID, @duration, @CallRevenue,@Pif ) ;
	
	if(@duration >2)
	  Begin
		if (@duration <30 AND (@AgentID not in (404,465)) and (@FacilityID not in (689,556,557)) and @billtype <>'08' ) 
			 SET @RejErrorcode=3 ;
		if (@duration <10  AND (@AgentID <>465) and @billtype <>'08')
			  SET @RejErrorcode=3 ;
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
			 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID ,@PIN, @facilityID, @duration, @CallRevenue,@Pif );

	  End

	If(@billtype = '07' ) 
	 Begin
	    select @CurrentBalance  = balance  from tbldebit with(nolock) where AccountNo = @creditCardNo;	
		if(@CurrentBalance > @CallRevenue)
	 		Update tbldebit SET balance = @CurrentBalance - @CallRevenue, modifydate = getdate(),userName=@UsedBy, status=1 where AccountNo = @creditCardNo	;
		else 	
			Update tbldebit SET balance = 0 , modifydate = getdate(),userName=@UsedBy, status=1 where AccountNo = @creditCardNo	;	
	 End	
	Else If(@billtype = '10')  -- Update balance
	 begin
			
			If(left(@toNo,3) <>  '011')
			 Begin
				Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName =@UsedBy, status=1 where PhoneNo =@toNo	;
				
			 End
			Else
			 Begin
				select 'TEST' , @toNo;
				Set  @countryCode = dbo.fn_determine_countryCode (@tono ) ;
				SET @phone = Substring(@tono, 4+ len(@countryCode) , len(@tono));
				select @phone, @countryCode;
				Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName ='Enduser',  status=1 where PhoneNo =@phone and Countrycode = @countryCode;
				
				
			 End

	  end
	  
	 
End	
If(@errorCode > 0 or @duration =0)
 Begin
	    if (@billtype ='07')
			update tblDebit set status=1, userName='EndUser' where AccountNo = @creditCardNo;
		else if (@billtype ='10')
		 begin
			If(left(@toNo,3) <>  '011')
				update tblprepaid set status=1 ,userName='EndUser'  where phoneno=@billtono;
			else
			 Begin					
					Set  @countryCode = dbo.fn_determine_countryCode (@tono ) ;
					SET @phone = Substring(@tono, 4+ len(@countryCode) , len(@tono));
					Update tblPrepaid SET  modifydate = getdate() , UserName ='Enduser',  status=1 where PhoneNo =@phone and Countrycode = @countryCode;					
					
			 End	
		 end
		EXEC  p_insert_unbilled_calls4  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, '',@creditCardNo,  @RecordDate,@callType, @RecordID ;
		If (@errorCode =7 or @errorCode =72)
				EXEC p_register_new_prepaid_Account3
									@FacilityID,	
									@tono,
									'Invalid Credit Card Transfer',
									@toCity,
									'', 
									@toState,
									1,
									'USA',
									'ICON Transfer',
									'For Prepaid',
									'no@email.com',
									@tono,
									'Auto',
									'NA',
									99,
									0,
									'' ;
		Else If ( @errorCode =70)
				EXEC p_register_new_prepaid_Account3
									@FacilityID,	
									@tono,
									'Call Info request',
									@toCity,
									'', 
									@toState,
									1,
									'USA',
									'ICON Transfer',
									'For Prepaid',
									'no@email.com',
									@tono,
									'Auto',
									'NA',
									99,
									0,
									'' ;
		Else If ( @errorCode =71)
				EXEC p_register_new_prepaid_Account3
									@FacilityID,	
									@tono,
									'Set up prepaid now',
									@toCity,
									'', 
									@toState,
									1,
									'USA',
									'ICON Transfer',
									'For Prepaid',
									'no@email.com',
									@tono,
									'Auto',
									'NA',
									99,
									0,
									'' ;
		--	Else 
		--	 begin
		--		If(@responseCode = '399'  )
		--			EXEC p_register_new_prepaid_Account4
		--								@FacilityID,	
		--								@tono,
		--								'Miss Call',
		--								@toCity,
		--								'', 
		--								@toState,
		--								1,
		--								'USA',
		--								'Call back',
		--								'For Prepaid',
		--								'no@email.com',
		--								@tono,
		--								'Auto',
		--								'NA',
		--								1,
		--								0,
		--								'',
		--								2 ;
		--	end
		-- end
	
 end
if(@PIN <> '0' )
 begin
	Delete tblinmateOncall where   pin =@PIN  and facilityID = @FacilityID;
	EXEC [dbo].[p_auto_insert_PAN] 		@facilityID ,@inmateID ,		@PIN ,	@ToNo;
 end
if(@@error =0)
  select '1'  as  SetBilledCalls ;
else
  select '0' as SetBilledCalls ;
