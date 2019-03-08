

CREATE PROCEDURE [dbo].[p_export_billing_record_temp]
@connectdate varChar(6)
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
	 ConnectTime,	dbo.fn_calculateDuration(duration, minDuration ,MinIncrement)  , MethodOfRecord, CallPeriod , RateClass,
	 CASE  WHEN billType='00' THEN '3' 
		WHEN  billType='01' THEN '4' 
		WHEN  billType='02' THEN '2'  END, 
	'4','0',  '0',Indicator19,BillToNo, Fromcity,FromState,ToCity,ToState,tblFacility.LibraryCode,SettlementCode ,
    dbo.fn_CalculateChargeAmt(firstMinute,nextMinute,connectFee,    dbo.fn_calculateDuration(duration, minDuration ,MinIncrement) ,   callType, TotalSurcharge, minDuration), '001'
	From  tblcallsBilled   With (nolock), tblFacility   With (nolock)
	WHERE  errorCode =0  and   tblFacility.FacilityID =  tblcallsBilled.FacilityID and
		  ( billType =  '00'  Or   billType =  '01'  or  billType =  '02'  ) 
		   and RecordDate >'11/6/2012'   and   RecordDate <'11/7/2012'  and calldate ='121107'
		  and convert (int,duration ) >5  --  AND 		    CAST(responsecode as int) <100
		   and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0) 
	EXEC p_writeBillingRecords  'ICONbillRecord' ,@connectdate 
	--select * from   ##tblBICtemp
	Drop table  ##tblBICtemp
