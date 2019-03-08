

CREATE PROCEDURE [dbo].[p_export_billing_record_BSG]
@Connectdate  char(6) 
 AS
SET NOCOUNT ON
EXEC p_create_tblTBRTemp
INSERT INTO ##tblTBRtemp( FromNo ,    ToNo ,         ConnectDate,ConnectTime, CallDuration, sequenceNo,  CCNo ,CCExp, 
                                    RatedCharge,filler, lib,MethodOfRecord )
select       CASE  isnull(DID,'')  when   '' then  FROMNO Else DID END, left(ToNo,14), CallDate,	LEFT( ConnectTime,4) ,	
	 dbo.fn_calculateDurationTBR(duration, minDuration,MinIncrement)  , right(CAST(RecordID as varchar(10)),5),	 creditCardNo , right(CreditCardExp,2) +left(CreditCardExp,2) ,
             right( dbo.fn_CalculateChargeAmt(firstMinute,nextMinute,connectFee,    dbo.fn_calculateDuration(101, minDuration,MinIncrement) ,   callType, TotalSurcharge, minDuration),5) ,
	settlementCode +  (CASE  CreditCardtype  
				WHEN  '1' THEN   'M' 
				WHEN '2' THEN  'V'
				 WHEN '3' THEN  'A' 
				WHEN '4' THEN  'S'
			 END )  	 + FromState + ToState + CASE WHEN  CreditcardZip <> ''  THEN  left(CreditcardZip,5)  ELSE  '     '   End + CreditCardCVV , tblFacility.libraryCode ,
			  CASE WHEN MethodOfRecord = '04' Then '1'  ELSE '2'  End 
	From  tblONcalls   With (nolock), tblFacility with(nolock) 
	WHERE   tblFacility.facilityID = tblOnCalls.facilityID AND
		  RecordDate > '9/24/2014' and  RecordDate < '9/25/2014'  and billType <'07' and duration =0 and ToNo in 
	(select BillToNo from TecoData.dbo.tblEndUser  where replyCode ='050')
	EXEC p_writeBSGRecords  @Connectdate
	--select * from   ##tblTBRtemp
	Drop table  ##tblTBRtemp
