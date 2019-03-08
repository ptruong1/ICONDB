

CREATE PROCEDURE [dbo].[p_export_billing_record_test]
@connectdate Char(6)
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
select  '010101', CallDate, '10', CASE isnull(DID,'')  when   '' then  FROMNO Else DID END,
	CASE WHEN callType ='IN' Then '011'  Else  '000' End,
	  CAST (len(ToNo) As char(2)),
	CASE WHEN  Substring(ToNo,1,3)  ='011'  THEN SUBSTRING(ToNo,4,10)  ELSE  left(ToNo,10) END,
	--ToNo,
	CASE WHEN    Substring(ToNo,1,3)  ='011'   THEN SUBSTRING(ToNo,14,9)  Else '000000000' END, 
	-- '000000000'  ,
	 ConnectTime,	dbo.fn_calculateDuration(600, minDuration ,MinIncrement)  , MethodOfRecord, CallPeriod , RateClass,
	 CASE  WHEN billType='00' THEN '3' 
		WHEN  billType='01' THEN '4' 
		WHEN  billType='02' THEN '2'  END, 
	'4','0',  '0',Indicator19,BillToNo, Fromcity,FromState,ToCity,ToState,tblFacility.LibraryCode,SettlementCode ,
    dbo.fn_CalculateChargeAmt(firstMinute,nextMinute,connectFee,    dbo.fn_calculateDuration(600, minDuration ,MinIncrement) ,   callType, TotalSurcharge, minDuration), '001'
	From  tblOncallsArchive   With (nolock), tblFacility   With (nolock)
	WHERE  tblFacility.FacilityID =  tblOncallsArchive.FacilityID AND
		  ( billType =  '01' ) and
		   recordDate >='11/1/2011'  and Responsecode='050'
		   and  errorcode ='2' 		   
		   and billtono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0)  
		   and tblOncallsArchive.AgentID not in (659,5)
	EXEC p_writeBillingRecords  'ICONbillRecordRecv' ,@connectdate 
	--select * from   ##tblBICtemp
	Drop table  ##tblBICtemp
