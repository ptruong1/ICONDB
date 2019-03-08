CREATE PROCEDURE [dbo].[p_insert_billed_calls_webservice_v2]
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
@duration		int,
@ActDuration	int,
@UserLanguage tinyint
 AS
SET NOCOUNT ON;
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) , @callRevenue numeric(6,2), @billtoNo char(10);
Declare  @Pif	numeric(4,2)  , @NSF numeric(4,2)   ,@PSC	numeric(4,2)   ,@NIF numeric(4,2) ,@BDF numeric(4,2)  ,@RAF 	numeric(4,2)  ,@BSF numeric(4,2)  ,@MaxCallTime int ;
Declare  @totalSurcharge  numeric(4,2)  ,@Fee2  numeric(4,2)   ,@Fee3  numeric(4,2) , @SChannel varchar(3), @status char (1) , @timeZone tinyint, @recordDate datetime, @settlementCode	char(1) ,@RateClass char(1);
Declare @countryCode varchar(4) , @phone varchar(13), @RejErrorcode tinyint, @UsedBy varchar(20), @CurrentBalance numeric(7,2), @RecordDest varchar(100), @AmtelFacilityID varchar(5);
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
SET @errorCode = isnull(@errorCode,0);
SET @RejErrorcode = @errorCode;
SET @CurrentBalance  =0;	
SET @duration = isnull(@duration,0);
SET @AmtelFacilityID ='0';
SET @MaxCallTime =900;
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

if(@creditcardno<>'' and len(@creditcardno) >10  and @billtype='01') SET  @billtype='05';

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

if (@duration >0) 
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
	/*
	if(@duration >2)
	  Begin
		if (@duration <30 AND (@AgentID not in (404,465)) and (@FacilityID not in (689,556,557)) and @billtype <>'08' ) 
			 SET @RejErrorcode=3 ;
		if (@duration <10  AND (@AgentID <>465) and @billtype <>'08')
			  SET @RejErrorcode=3 ;
        if(@BillType in ('03','05') or len(@creditCardNo) >13)
		 begin
			Declare @CCEncr  varbinary(200);
			EXEC [leg_Icon].dbo.[LegEncrypt] @creditCardNo,	@CCEncr  OUTPUT ;
		 end
		If(@Surcharge > 0 )
			Begin
				EXEC p_get_surcharge_detail @FacilityID ,@calltype ,@fromState	,@Pif	   OUTPUT , @NSF    OUTPUT ,@PSC	  OUTPUT ,@NIF  OUTPUT , @BDF  OUTPUT ,@RAF   OUTPUT , @BSF   OUTPUT ,@Fee2   OUTPUT,@Fee3  OUTPUT ;
			End
		 INSERT INTO  tblCallsbilled( RecordID,Calldate, ConnectTime, FromNo ,   ToNo, BillToNo , MethodOfRecord ,billType,callType, FromState, FromCity , 
			ToState, ToCity, CallPeriod,  CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,CreditCardZip,settlementCode,
		 	userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,ResponseCode,
			AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID,duration, CallRevenue, PIF, CCEncr)
		 Values(@recordID,@Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,'04', @billType,@callType, @FromState, @FromCity ,  
			@ToState, @ToCity,  @CallPeriod,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,@zipcode, @settlementCode,
			@UserName,@RejErrorcode, @RateClass, @firstMinute,@addMinute,@connectFee,@Surcharge,@MinDuration,@recordDate,@ratePlanID,@ResponseCode,
			 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID ,@PIN, @facilityID, @duration, @CallRevenue,@Pif,@CCEncr );
	  
	  End
   */
	If(@billtype = '07' ) 
	 Begin
		if(@AgentID =7)
		 begin
			select @CurrentBalance = PhoneBalance from tblMaineLogs with(nolock) where ReferenceNo= @RecordID and APItype=1 ;
				if(@CurrentBalance =0)
					select @CurrentBalance  = balance  from tbldebit with(nolock) where AccountNo = @creditCardNo;	
		 end
		else if(@AgentID =102)
		 begin
			select @CurrentBalance = PhoneBalance from tblAmtelLogs with(nolock) where ReferenceNo= @RecordID and APItype=2 ;
		 end
		else
		 begin
			If(@FacilityID =807 and @calltype ='IN' and @duration <30)
				Begin
					Set @RejErrorcode=25;
				End
			select @CurrentBalance  = balance  from tbldebit with(nolock) where AccountNo = @creditCardNo;	
		 end

		If(@AgentID <>102 and  @RejErrorcode <>25)
		 begin
			if(@CurrentBalance > @CallRevenue)			 
	 			Update tbldebit SET balance = @CurrentBalance - @CallRevenue, modifydate = getdate(),userName=@UsedBy, status=1 where AccountNo = @creditCardNo	;
			else 	
				Update tbldebit SET balance = 0 , modifydate = getdate(),userName=@UsedBy, status=1 where AccountNo = @creditCardNo	;
			
		 end		
	 End	
	Else If(@billtype = '10')  -- Update balance
	 begin
	  
			If(left(@toNo,3) <>  '011')
			 Begin
				Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName =@UsedBy, status=1, FacilityID=@FacilityID where PhoneNo =@toNo	;
				
			End
			Else
			 Begin
				
				Set  @countryCode = dbo.fn_determine_countryCode (@tono ) ;
				SET @phone = Substring(@tono, 4+ len(@countryCode) , len(@tono));
				Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName ='Enduser',  status=1, FacilityID=@FacilityID where PhoneNo =@phone and Countrycode = @countryCode;
			 End

	  end
	Else if(@billtype ='08' or @BillType ='19')
	 begin
		 Update tblInmate set  FreeCallRemain=FreeCallRemain - 1  where facilityID = @facilityID and  InmateID=@inmateID and FreeCallRemain > 0;
	 end

	 --- Move 
	if(@duration >1)
	  Begin
		--if (@duration <30 AND (@AgentID not in (404,465,102)) and (@FacilityID not in (689,556,557,786)) and @billtype not in ('08','19','17' ) )
		--	 SET @RejErrorcode=3 ;
		--if (@duration <10  AND (@AgentID not in (102,465)) and @billtype <>'08')
		--	  SET @RejErrorcode=3 ;
        if(@BillType in ('03','05') or len(@creditCardNo) >13)
		 begin
			Declare @CCEncr  varbinary(200);
			EXEC [leg_Icon].dbo.[LegEncrypt] @creditCardNo,	@CCEncr  OUTPUT ;
		 end
		
		If(@Surcharge > 0 )
			Begin
				EXEC p_get_surcharge_detail @FacilityID ,@calltype ,@fromState	,@Pif	   OUTPUT , @NSF    OUTPUT ,@PSC	  OUTPUT ,@NIF  OUTPUT , @BDF  OUTPUT ,@RAF   OUTPUT , @BSF   OUTPUT ,@Fee2   OUTPUT,@Fee3  OUTPUT ;
			End
        
	
		If(@errorCode <10 )
		 Begin
			 INSERT INTO  tblCallsbilled( RecordID,Calldate, ConnectTime, FromNo ,   ToNo, BillToNo , MethodOfRecord ,billType,callType, FromState, FromCity , 
				ToState, ToCity, CallPeriod,  CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,CreditCardZip,settlementCode,
		 		userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,ResponseCode,
				AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID,duration, CallRevenue, PIF, CCEncr, AcDuration, UserLanguage, phoneType)
			 Values(@recordID,@Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,'04', @billType,@callType, @FromState, @FromCity ,  
				@ToState, @ToCity,  @CallPeriod,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,@zipcode, @settlementCode,
				@UserName,@RejErrorcode, @RateClass, @firstMinute,@addMinute,@connectFee,@Surcharge,@MinDuration,@recordDate,@ratePlanID,@ResponseCode,
				 @AgentID,@RecordFileName,@increment, '0',@folderDate	,@inmateID ,@PIN, @facilityID, @duration, @CallRevenue,@Pif,@CCEncr, @ActDuration, @UserLanguage, dbo.p_determine_phonetype(@ToNo) );
		 End
	  End

	 -- add new table
	insert tblphonecalls ( facilityId,InmateID , FromNo,ToNo , billType , CallType , Callduration , CallRevenue, RecordDate)
	values( @FacilityID ,@inmateID, @fromNo,@toNo , @BillType, @callType , @duration , @callRevenue ,@recordDate ); 
	 
End	
If(@errorCode > 0 or @duration =0)
 Begin
	    if (@billtype ='07')
			update tblDebit set [status]=1, userName='EndUser' where AccountNo = @creditCardNo;
		else if (@billtype ='10')
		 begin
			If(left(@toNo,3) <>  '011')
				update tblprepaid set status=1 ,userName='EndUser'  where phoneno=@tono;
			else
			 Begin					
					Set  @countryCode = dbo.fn_determine_countryCode (@tono ) ;
					SET @phone = Substring(@tono, 4+ len(@countryCode) , len(@tono));
					Update tblPrepaid SET  modifydate = getdate() , UserName ='Enduser',  status=1, FacilityID=@FacilityID where PhoneNo =@phone and Countrycode = @countryCode;					
					
			 End	
		 end
        If(@errorCode < '75')
			EXEC  p_insert_unbilled_calls_v2  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, '',@creditCardNo,  @RecordDate,@callType, @RecordID, @ActDuration, @RecordFileName, @UserLanguage  ;
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
		
		Else If ( @errorCode =5)
		 begin
			IF (select COUNT(PhoneNo ) from [tblBlockedPhones] with(nolock) Where (FacilityID=@FacilityID or FacilityID=1) and PhoneNo =@toNo )=0
			begin
				INSERT INTO [tblBlockedPhones] ([PhoneNo], [FacilityID], [ReasonID], [Descript], [UserName], [RequestID], [TimeLimited],inputDate ) 
				 VALUES (@toNo, @FacilityID, 1, 'End user request', @toNo,2, null,@recordDate);
			end
		 end

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
--if(@PIN <> '0' )
-- begin
--	Delete tblinmateOncall where   (pin =@PIN  or pin =@inmateID) and facilityID = @FacilityID;
--	EXEC [dbo].[p_auto_insert_PAN] 		@facilityID ,@inmateID ,		@PIN ,	@ToNo;
-- end

--If(@folderDate >'161221')
	--select  @RecordDest= '\\172.77.10.21\Mediafiles1\'+  ComputerName from tblACPs with(nolock) where IpAddress = @userName
	select  @RecordDest= 'Y:\'+  ComputerName from tblACPs with(nolock) where IpAddress = @userName
--else
	--select  @RecordDest= '\\172.77.10.20\Mediafiles\'+  ComputerName from tblACPs with(nolock) where IpAddress = @userName



If(@PIN >'0')
 begin
    Declare @NameRecordOpt tinyint, @BioMetricOpt tinyint, @NameRecorded tinyint, @BioRegister tinyint ;
	SET @NameRecordOpt =0;
	SET @BioMetricOpt =0; 
	SET  @NameRecorded =0;
	SET  @BioRegister =0;
	Select @NameRecordOpt =NameRecord,@BioMetricOpt= BioMetric  from tblFacilityOption with(nolock) where  facilityID = @facilityID;
	if(@NameRecordOpt=1 or @BioMetricOpt=1)
	 begin
		
		select  @NameRecorded= isnull(NameRecorded,0), @BioRegister = BioRegister from  tblInmate with(nolock) where  facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;
		if(@NameRecordOpt=1 and @BioMetricOpt=1 and (@BioRegister=0 or @NameRecorded=0))
			Update tblInmate set NameRecorded=1, BioRegister=1 where facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;
		else if(@NameRecordOpt=1 and @BioMetricOpt=0  and @NameRecorded=0)
			Update tblInmate set NameRecorded=1 where facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;
		else if(@NameRecordOpt=0 and @BioMetricOpt=1  and @BioRegister=0)
			Update tblInmate set  BioRegister=1 where facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;

	 end

	 Delete tblinmateOncall where   (pin =@PIN  or pin =@inmateID) and facilityID = @FacilityID;
	 EXEC [dbo].[p_auto_insert_PAN] 		@facilityID ,@inmateID ,		@PIN ,	@ToNo;
 end
update tblOncalls set duration = @duration, lastModify =@recordDate, errorCode=@errorCode,  ResponseCode =@ResponseCode,  CreditCardType = @CreditCardType,   CreditCardNo = @CreditCardNo  ,     CreditCardExp =@CreditCardExp,   CreditCardZip= @zipcode , CreditCardCVV =@cvv, billtype=@billtype  where  RecordID = @RecordID;

if(@AgentID =102)
 begin
	select  @AmtelFacilityID  =isnull( FTPfolderName,'0') from tblFacilityOption with(nolock) where FacilityID=@FacilityID;
	SET @recordDate = dateadd(second,- @duration,@recordDate);

	--if(@CurrentBalance > 0 and @CurrentBalance < @callRevenue  and @duration > 60)
	-- begin
	--		SET @duration = @duration- 60;
	-- end	

	If(@duration < @MaxCallTime)
		SET @MaxCallTime = @duration;
 end


if(@@error =0)
 
  select '1'  as  SetBilledCalls, @RecordDest as RecordDest, @callRevenue as CallRevenue, @AmtelFacilityID as AmtelFacilityID, @recordDate  as recordDate, @MaxCallTime as MaxCallTime ;

else
  select '0' as SetBilledCalls, @RecordDest as RecordDest,  @callRevenue as CallRevenue, @AmtelFacilityID  as AmtelFacilityID, @recordDate as recordDate, @MaxCallTime as MaxCallTime ;


 If(@AgentID = 7 and  @Duration >0)
 Begin
	SET @Duration = Ceiling((@Duration /60.00));
	EXEC p_insert_queue 3,	@PIN  ,	@InmateID  ,	@FromNo  ,	@ToNo	,	@RecordID ,	@Duration ,@CallRevenue ;
 End

 Return 0;
