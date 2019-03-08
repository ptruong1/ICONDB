
CREATE PROCEDURE [dbo].[p_insert_CallRecord6]
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
@creditCardNo		varchar(20),   --- Using for Calling Card or Creditcard or PIN
@creditCardExp		varchar(4),
@libraryCode	varchar(2),
@BillType	varchar(2) , -- 00 calling card, 01 collect, 02 third party, 03 credit card , 
@callType	varchar(2),  -- calltype such as ST, RL, DA
@indicator19		char(1),
@projectCode		varchar(6),
@userName		varchar(23),
@errorCode		tinyint,
@firstMinute		numeric(6,4),
@addMinute		numeric(6,4),
@connectFee		numeric(6,4),
@pip			numeric(6,4),
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
@increment		tinyint,
@FacilityID	int,
@RecordFileName	varchar(20),
@channel		tinyint,
@folderDate		char(8),
@inmateID		varchar(12),
@PIN			varchar(12),
@InRecordFile		varchar(12),
@RecordID		bigint
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) ,@settlementCode	char(1)
Declare  @totalSurcharge  numeric(4,2)  , @SChannel varchar(3), @status char (1) ,  @timeZone tinyint, @recordDate datetime ,@RateClass		char(1)
SET @trunKID = ''
SET @YY = right(@callDate,2)
SET @MM=Left(@callDate,2)
SET @RateClass	='6'

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


If ( @BillType = '08'  or  @billtype='13')
 Begin
	SET @fromstate=''
	SET @fromCity =''
	SET @toState=''
	SET @toCity =''
	SET @PIP =0
	SET @firstMinute =0
	SET @addMinute =0
	SET @connectFee =0
	SET @callType ='NA'
 End
Else 
 Begin

	IF (@BillType = '01' )  	SET  @billToNo = @toNo
	
	If(@responseCode = '800'  and  @BillType = '01' ) 
		 SET @BillType ='12'
	
	IF  (LEFT(@toNo,3) = '011'  Or  @calltype = 'IN')
		SET  @SettlementCode  = 'N'
	ELSE
		EXEC  p_determine_setlementCode  @fromState	,@toState	,@fromLata	,@tolata	, @SettlementCode	 Output
  End

select  @timeZone  = timezone from tblfacility with(nolock)  where facilityID = @facilityID 
Set  @recordDate = getdate()
set @recordDate = dateadd(hh, @timeZone, @recordDate) 


 INSERT INTO  tblOnCalls( RecordID, Calldate, ConnectTime, FromNo ,   ToNo, BillToNo ,  MethodOfRecord,billType,callType, FromState, FromCity ,  
	ToState, ToCity, CallPeriod,LibraryCode, Indicator19, SettlementCode, CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,
 	ProjectCode ,userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,DbError,ResponseCode,
	AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID, InRecordFile, lastModify	)
 Values( @RecordID, @Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,  @MethodOfRecord,@billType,@callType, @FromState, @FromCity , 
	@ToState, @ToCity,  @CallPeriod,@LibraryCode, @Indicator19, @SettlementCode,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,
	@ProjectCode ,@UserName,@errorCode, @RateClass, @firstMinute,@addMinute,@connectFee,@Pip,@MinDuration,@recordDate,@ratePlanID,@DbError, @ResponseCode,
	 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID,@PIN, @facilityID, @InRecordFile,  @recordDate)


If(@errorCode =  0)
 Begin
   /*
   	SET  @status='A'
	Update tblLiveMonitor SET 
	ProjectCode = @projectcode,
	RecordID	=  @RecordID,
	 CallingNo = @fromNo ,
	 CallDate      = @calldate,
	 CallTime  =  @ConnectTime,
	  CalledNo = @tono,
	  InmateID  = @inmateID,
	  PIN	  = @PIN,
	   Billtype    = @billType,
	HostName = @UserName,
	  Channel  = @Channel,
	 FolderDate= @folderDate,
	 RecordFileName =@RecordFileName, 
	 Status  = @status , duration = 0, LastUpdate = getdate()  
	WHERE  ( (CallingNo = @fromNo and (watchby=1  Or  watchby=4)  ) Or ( CalledNo = @Tono  and watchby=2)  Or  ( PIN = @PIN  and watchby=3))
	And  CalledNo  not in (select PhoneNo  from tblNonRecordPhones  with(nolock))
	*/
	If (@billtype >'12')
		EXEC  p_insert_unbilled_calls3 @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, @projectcode,@creditCardNo, @RecordDate ,@Calltype
 
	else if (@billtype ='07')
		update tblDebit set status=2, userName='Oncall' where AccountNo = @creditCardNo
	else if (@billtype ='10')
		update tblprepaid set status=2,userName='Oncall'  where phoneno=@billtono
 end
Else
  Begin
	EXEC  p_insert_unbilled_calls3  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, @projectcode,@creditCardNo,  @RecordDate ,@Calltype
	If(@errorCode =  5)
	  Begin
		if (select count(*) from  tblFreePhones with(nolock)  where PhoneNo   =@tono ) = 0
			Insert tblblockedPhones( PhoneNo,    FacilityID,  ReasonID, RequestID, UserName) values(@tono, @facilityID, 1,2,'Auto')
	  End
  End
