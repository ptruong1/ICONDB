﻿
CREATE PROCEDURE [dbo].[p_insert_billed_calls3]
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
@userName		varchar(23),
@errorCode		tinyint,
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
@AgentID		varchar(7),
@increment		tinyint,
@FacilityID	int,
@RecordFileName	varchar(20),
@channel		tinyint,
@folderDate		char(8),
@inmateID		varchar(12),
@PIN			varchar(12),
@InRecordFile		varchar(12),
@Duration		int,
@recordID		bigint	
 AS
SET NOCOUNT ON
Declare  @YY  char(2), @MM char(2), @tblCall  varchar(20),  @SQL  varchar(500),  @callPeriod  char(1), @HH smallint, @trunKID varchar(4) , @callRevenue numeric(6,2)
Declare  @Pif	numeric(4,2)  , @NSF numeric(4,2)   ,@PSC	numeric(4,2)   ,@NIF numeric(4,2) ,@BDF numeric(4,2)  ,@RAF 	numeric(4,2)  ,@BSF numeric(4,2)   
Declare  @totalSurcharge  numeric(4,2)  ,@Fee2  numeric(4,2)   ,@Fee3  numeric(4,2) , @SChannel varchar(3), @status char (1) , @timeZone tinyint, @recordDate datetime, @settlementCode	char(1) ,@RateClass char(1)
SET @RateClass ='6'
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
SET @callRevenue  =0

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

If( select count(*) from tblfacility with(nolock) where  facilityID =@facilityID and recordOpt ='Y' ) =0
	SET @RecordFileName='NA'

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

select  @timeZone  = isnull(timezone,0) from tblfacility with(nolock)  where facilityID = @facilityID 
Set  @recordDate = getdate()
set @recordDate = dateadd(hh, @timeZone, @recordDate) 

If(@billtype =  '06')
 Begin
	/*
	
	Insert tblcallsBilled(RecordID, Calldate, ConnectTime, FromNo,ToNo ,BillToNo , MethodOfRecord ,billType, CallType, FromState ,FromCity ,  ToState, ToCity,
		 CreditCardType, CreditCardNo ,CreditCardExp,CreditCardZip ,CreditCardCVV ,CallPeriod, LibraryCode ,Indicator19,SettlementCode ,ProjectCode,
	 	complete ,errorCode ,ratePlanID, firstMinute , nextMinute ,  connectFee ,  minDuration ,RateClass, userName ,RecordDate  ,Totalsurcharge,duration ,
	 	Dberror, ResponseCode, AuthName ,ConfigID ,Pif ,   NSF ,PSC , NIF, BDf, RAF ,BSF ,OpSeqNo, AgentID, Fee2 ,  Fee3 , RecordFile,InRecordFile,
	  	MinIncrement, FolderDate, Channel, InmateID,CallRevenue,PIN, facilityID,BadDebtRate,CommRate) 
	select   A.RecordID, L.Calldate, L.ConnectTime, L.FromNo,L.ToNo ,L.BillToNo , L.MethodOfRecord ,L.billType, L.CallType, L.FromState ,L.FromCity ,  L.ToState, L.ToCity,
		 L.CreditCardType, L.CreditCardNo ,L.CreditCardExp,L.CreditCardZip ,L.CreditCardCVV ,L.CallPeriod, L.LibraryCode ,L.Indicator19,L.SettlementCode ,L.ProjectCode,
	 	L.complete ,L.errorCode ,L.ratePlanID, L.firstMinute , L.nextMinute ,  L.connectFee ,  L.minDuration ,L.RateClass, A.userName ,L.RecordDate  ,L.Totalsurcharge,   @duration ,
		 L.Dberror, L.ResponseCode, L.AuthName ,L.ConfigID, L.Pif ,   L.NSF ,L.PSC , L.NIF, L.BDf, L.RAF ,L.BSF ,L.OpSeqNo, L.AgentID, L.Fee2 ,  L.Fee3 , A.RecordFile,  A.InRecordFile, 
	 	 L.MinIncrement, A.FolderDate, A.Channel, A.InmateID , dbo.fn_CalculateCallRevenue(L.firstMinute  , L.NextMinute ,L.connectFee , @duration ,L.callType  , L.totalSurcharge  ,L.minDuration ) ,A.PIN  , A.facilityID,
		 dbo.fn_getCurrentBadDebt( L.AgentID , L.FacilityID, L.BillType ,L.Calltype ) ,   dbo.fn_getCurrentCommRate( L.AgentID , L.FacilityID,L.BillType ,L.Calltype ) 
	from tblOncalls  A with(nolock) ,   tblcallsLive  L with(nolock) 
	where  A.projectcode = L.ProjectCode and  A.calldate = L.Calldate and 
	 A.projectcode= @projectCode and    A.calldate= @calldate  and  L.errorCode ='0'  
	*/
	update tblOncalls set duration = @duration where  RecordID = @RecordID
 End

else 

 begin
	Update  tblLivemonitor   SET  status = 'C',   duration =  @duration , LastUpdate = getdate()    where   RecordID = @RecordID 
	SET @callRevenue = dbo.fn_CalculateCallRevenue(@firstMinute  ,@addMinute ,@connectFee ,@duration ,@callType  ,@PIP  ,@minDuration ) 
	If(@billtype = '07'  and @duration >10 ) 
	 Begin
		
		SET @callRevenue = dbo.fn_CalculateCallRevenue(@firstMinute  ,@addMinute ,@connectFee ,@duration ,@callType  ,@PIP  ,@minDuration ) 
		Update tbldebit SET balance = balance - @CallRevenue, modifydate = getdate() where AccountNo = @creditCardNo	
		Update tbldebit SET balance = 0 , modifydate = getdate() where AccountNo =  @creditCardNo	 and balance <0
	 End
	
	
	if(@duration >10)
	  Begin
		 INSERT INTO  tblCallsbilled( RecordID,Calldate, ConnectTime, FromNo ,   ToNo, BillToNo ,  MethodOfRecord,billType,callType, FromState, FromCity ,  
			ToState, ToCity, CallPeriod,LibraryCode, Indicator19, SettlementCode, CreditCardType, CreditCardNo , CreditCardExp,CreditCardCvv,
		 	userName,errorCode, rateClass,firstMinute,nextMinute,connectFee, TotalSurcharge,MinDuration,recordDate,ratePlanID,DbError,ResponseCode,
			AgentID, RecordFile, MinIncrement, channel, folderDate, InmateID,PIN,facilityID, InRecordFile	,duration, CallRevenue)
		 Values(@recordID,@Calldate, @ConnectTime, @FromNo ,@ToNo, @BillToNo ,  @MethodOfRecord,@billType,@callType, @FromState, @FromCity , 
			@ToState, @ToCity,  @CallPeriod,@LibraryCode, @Indicator19, @SettlementCode,  @creditCardType, @creditCardNo, @creditCardExp, @cvv,
			@UserName,@errorCode, @RateClass, @firstMinute,@addMinute,@connectFee,@Pip,@MinDuration,@recordDate,@ratePlanID,@DbError, @ResponseCode,
			 @AgentID,@RecordFileName,@increment, @channel,@folderDate	,@inmateID,@PIN, @facilityID, @InRecordFile,@duration, @CallRevenue)

	  End
		
		
	If(@billtype = '10 '  AND  @creditCardNo =''   and  @duration >10)  -- Update balance
	  Begin
		If(left(@toNo,3) <>  '011')
		 Begin
			Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName ='Enduser' where PhoneNo =@toNo	
			--Update tblPrepaid SET balance =0 , modifydate = getdate() , UserName ='Enduser' where PhoneNo =@toNo	 and  balance <0
		End
		Else
		 Begin
			Declare @countryCode varchar(4) , @phone varchar(10)
			Set  @countryCode = dbo.fn_determine_countryCode (@tono ) 
			SET @phone = Substring(@tono, 4+ len(@countryCode) , len(@tono))
			Update tblPrepaid SET balance = balance -  @CallRevenue, modifydate = getdate() , UserName ='Enduser' where PhoneNo =@phone and Countrycode = @countryCode
			--Update tblPrepaid SET balance =0 , modifydate = getdate() , UserName ='Enduser' where PhoneNo =@phone and Countrycode = @countryCode and  balance <0  
			
		 End

	  end
	If(@errorCode	='0')
		update tblOncalls set duration = @duration, lastModify = @recordDate where  RecordID = @RecordID
 end
