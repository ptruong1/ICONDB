
CREATE PROCEDURE [dbo].[p_insert_CallRecord7]
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
@projectCode		varchar(6),
@userName		varchar(23),
@errorCode		tinyint,
@firstMinute		numeric(6,4),
@addMinute		numeric(6,4),
@connectFee		numeric(6,4),
@pip			numeric(6,4),
@MinDuration		smallint,
@ratePlanID		varchar(7),
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
@RecordID		bigint,
@phoneType		tinyint
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) ,@settlementCode	char(1)
Declare  @totalSurcharge  numeric(4,2)  , @SChannel varchar(3), @status char (1) ,  @timeZone tinyint, @recordDate datetime ,@RateClass		char(1),@duration  int
SET @trunKID = ''
SET @YY = right(@callDate,2)
SET @MM=Left(@callDate,2)
SET @RateClass	='6'


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
	
	If(@responseCode = '800'  and  @BillType = '01' )   SET @BillType ='12'
	
  End

select  @timeZone  = timezone from tblfacility with(nolock)  where facilityID = @facilityID 
Set  @recordDate = getdate()
set @recordDate = dateadd(hh, @timeZone, @recordDate) 
if(@errorCode > 0)  SET @duration = 0

 INSERT INTO  tblOnCalls( RecordID, Calldate, ConnectTime, FromNo ,   ToNo, BillToNo ,  MethodOfRecord,billType,callType, FromState, FromCity ,  
	ToState, ToCity, CallPeriod,LibraryCode, CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,
 	ProjectCode ,userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,DbError,ResponseCode,
	AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID, InRecordFile, lastModify,phoneType,duration	)
 Values( @RecordID, @Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,  @MethodOfRecord,@billType,@callType, @FromState, @FromCity , 
	@ToState, @ToCity,  @CallPeriod,@LibraryCode,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,
	@ProjectCode ,@UserName,@errorCode, @RateClass, @firstMinute,@addMinute,@connectFee,@Pip,@MinDuration,@recordDate,@ratePlanID,@DbError, @ResponseCode,
	 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID,@PIN, @facilityID, @InRecordFile,  @recordDate,@phoneType,@duration)


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
	If (@billtype >12)
		EXEC  p_insert_unbilled_calls2 @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, @projectcode,@creditCardNo, @RecordDate 
	else if (@billtype ='07')
		update tblDebit set status=2, userName='Oncall' where AccountNo = @creditCardNo
	else if (@billtype ='10')
		update tblprepaid set userName='Oncall'  where phoneno=@billtono
 end
Else
  Begin
	EXEC  p_insert_unbilled_calls2  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, @projectcode,@creditCardNo,  @RecordDate 
	If(@errorCode =  5)
	  Begin
		if (select count(*) from  tblFreePhones with(nolock)  where PhoneNo   =@tono ) = 0
			Insert tblblockedPhones( PhoneNo,    FacilityID,  ReasonID, RequestID, UserName) values(@tono, @facilityID, 1,2,'Auto')
	  End
  End
