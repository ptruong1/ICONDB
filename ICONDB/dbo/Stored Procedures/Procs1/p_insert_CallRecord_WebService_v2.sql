
CREATE PROCEDURE [dbo].[p_insert_CallRecord_WebService_v2]
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
@UserLanguage  tinyint
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) ,@settlementCode	char(1),  @billToNo char(10);
Declare  @totalSurcharge  numeric(4,2)  , @SChannel varchar(3), @status char (1) ,  @timeZone tinyint, @recordDate datetime ,@RateClass		char(1), @duration int;
SET @trunKID = '';
SET @YY = right(@callDate,2);
SET @MM=Left(@callDate,2);
SET @RateClass	='6';
If(@callType ='' or @callType is null)
	SET @callType ='NA';
if(@creditcardno<>'' and @billtype='01') 
	SET  @billtype='05';
If ( @BillType = '08'  or  @billtype='13')
 Begin
	SET @fromstate='';
	SET @fromCity ='';
	SET @toState='';
	SET @toCity ='';
	SET @Surcharge =0;
	SET @firstMinute =0;
	SET @addMinute =0;
	SET @connectFee =0;
	SET @callType ='NA';
 End
Else If (@BillType = '' or @BillType is null )  	
		SET @BillType = '09'; 
Else 
 Begin
	
	IF (@BillType = '01' )  	
		SET  @billToNo = @toNo;
  End
if(ltrim(@PIN) ='')
begin
  	SET @PIN ='0';
	SET @InmateID ='0';
end
select  @timeZone  = timezone from tblfacility with(nolock)  where facilityID = @facilityID ;
Set  @recordDate = getdate();
set @recordDate = dateadd(hh, @timeZone, @recordDate) ;
Set @settlementCode =  dbo.[fn_determine_setlementCode]( @fromState,@toState,'0','0')  ;
if(@errorCode > 0)  
 begin
	SET @duration = 0;
	if (@pin <>'0') 
	 begin
		 Delete tblinmateOncall where   (pin =@PIN  or InmateID =@inmateID) and facilityID = @FacilityID;
	 end
 end

 INSERT INTO  tblOnCalls( RecordID, Calldate, ConnectTime, FromNo ,   ToNo, BillToNo , MethodOfRecord , billType,callType, FromState, FromCity , 
	ToState, ToCity, CallPeriod, CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,CreditCardZip,settlementCode,
 	userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,ResponseCode,
	AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID, InRecordFile, lastModify, duration, UserLanguage, phonetype )
 Values( @RecordID, @Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,'04', @billType,@callType, @FromState, @FromCity ,  
	@ToState, @ToCity,  @CallPeriod,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,@zipcode,@settlementCode,
	@UserName,@errorCode, @RateClass, @firstMinute,@addMinute,@connectFee,@Surcharge,@MinDuration,@recordDate,@ratePlanID, @ResponseCode,
	 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID ,@PIN, @facilityID, @InRecordFile,  @recordDate,@duration, @UserLanguage, dbo.p_determine_phonetype(@ToNo) );


If(@errorCode =  0)
 Begin
	
	If (@billtype >12)		
		EXEC  p_insert_unbilled_calls_v2  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, '',@creditCardNo,  @RecordDate,@callType, @RecordID, 0, '' , @UserLanguage ;
	--else if (@billtype ='07')
	--	update tblDebit set [status]=3, userName='Oncall', modifyDate = GETDATE() where AccountNo = @creditCardNo;
	else if (@billtype ='10')
		update tblprepaid set userName='Oncall'  where phoneno=@billtono ;

	/*
	If (@AgentID =7)
	 begin
		INSERT INTO [dbo].[tblCallsInQueue]
				   ([PIN]
				   ,[InmateID]
				   ,[FromNo]
				   ,[ToNo]
				   ,[ProcessType]
				   ,[Duration]
				   ,[Charge]
				   ,[RecordID]
				   ,[InputTime])
			 VALUES
				   (@PIN
				   ,@InmateID
				   ,@FromNo
				   ,@ToNo
				   ,2
				   ,0
				   ,0
				   ,@RecordID 
				   ,getdate())
	 end

	*/

 end
Else
  Begin
	If(@BillType<>'07')
		EXEC  p_insert_unbilled_calls_v2  @calldate,@connecttime,  @fromno  ,@tono	,@billtype	,@errorCode	,@PIN		,@inmateID	,@facilityID	,@userName,@responseCode, '',@creditCardNo,  @RecordDate,@callType, @RecordID, 0, '' , @UserLanguage ;
	if(@BillType='07')
		Update tbldebit set modifydate = getdate(), status=1 where FacilityID =@FacilityID and  InmateID = @inmateID;	
	else if (@BillType='10')
		Update tblprepaid set modifydate = getdate(), status=1 where PhoneNo= @toNo;
  End


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
		select  @NameRecorded=ISNULL( NameRecorded,0), @BioRegister = BioRegister  from  tblInmate with(nolock) where  facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;
		if(@NameRecordOpt=1 and @BioMetricOpt=1 and (@BioRegister=0 or @NameRecorded=0))
			Update tblInmate set NameRecorded=1, BioRegister=1 where facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;
		else if(@NameRecordOpt=1 and @BioMetricOpt=0  and @NameRecorded=0)
			Update tblInmate set NameRecorded=1 where facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;
		else if(@NameRecordOpt=0 and @BioMetricOpt=1  and @BioRegister=0)
			Update tblInmate set  BioRegister=1 where facilityID = @facilityID and PIN=@pin and InmateID=@inmateID;

	 end
 end

if(@@error =0)
  select '1'  as  SetCalls;
else
  select '0' as SetCalls;
