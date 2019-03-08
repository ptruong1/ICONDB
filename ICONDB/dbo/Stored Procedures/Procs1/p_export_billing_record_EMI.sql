

CREATE PROCEDURE [dbo].[p_export_billing_record_EMI]
@facilityID int,
@ConnectDateYYMM Char(4)
 AS
SET NOCOUNT ON
EXEC p_create_tblBicTemp

INSERT INTO ##tblBICtemp( RecordID, CallDate, FromNoLength,FromNo ,
	Unused1, 
	ToNoLength ,
	ToNo, 
	Unused2,
	ConnectTime,	BillableTime, 	MethodOfRecord,   RatePeriod ,RateClass, 
	MessageType, 
	 Indicator1, Indicator6,  Indicator8,  Indicator19,  BillToNo,   FromCity ,  FromState, ToCity ,    ToState ,LibraryCode, SettlementCode,
	ChargeAmt, entityCode)
	
select    '010101', CallDate, '10', CASE isnull(DID,'')  when   '' then  FROMNO Else DID END,
	CASE WHEN callType ='IN' Then '011'  Else  '000' End,
	  CAST (len(ToNo) As char(2)),
	CASE WHEN  Substring(ToNo,1,3)  ='011'  THEN SUBSTRING(ToNo,4,10)  ELSE  left(ToNo,10) END,
	--ToNo,
	CASE WHEN    Substring(ToNo,1,3)  ='011'   THEN SUBSTRING(ToNo,14,9)  Else '000000000' END, 
	-- '000000000'  ,
	 ConnectTime,	dbo.fn_calculateDuration(a.facilityID , minDuration ,MinIncrement)  , MethodOfRecord, CallPeriod , RateClass,
	 '4', 
	'4','0',  '0',Indicator19,ToNo, left(Fromcity,10),FromState,left(ToCity,10),ToState,'9D',SettlementCode ,
    dbo.fn_CalculateChargeAmt(firstMinute,nextMinute,connectFee,    dbo.fn_calculateDuration(a.facilityID, minDuration ,MinIncrement) ,   callType, TotalSurcharge, minDuration), '001'
	From  tblcallsbilled  a   With (nolock), tblFacility b  with(nolock) 
	WHERE   b.facilityID = a.facilityID AND a.facilityID  =@facilityID  and
		  left(Calldate,4)=@ConnectDateYYMM  and billtype ='01';
	Update ##tblBICtemp set RatePeriod = dbo.[fn_determine_callPeriod](Calldate,ConnectTime);
	Update ##tblBICtemp set indicator19 =[dbo].[fn_determineIndicator19] (fromState,toState);
	EXEC p_writeBillingRecords  'CDREMI' ,@connectdateYYMM ;
	--select * from   ##tblBICtemp
	Drop table  ##tblBICtemp;
	


	
