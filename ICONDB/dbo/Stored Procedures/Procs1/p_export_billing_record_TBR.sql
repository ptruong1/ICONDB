

CREATE PROCEDURE [dbo].[p_export_billing_record_TBR]
@Connectdate  char(6) 
 AS
SET NOCOUNT ON
EXEC p_create_tblTBRTemp
INSERT INTO ##tblTBRtemp( FromNo ,    ToNo ,         ConnectDate,ConnectTime, CallDuration, sequenceNo,  CCNo ,CCExp, 
                                    RatedCharge,filler, lib,MethodOfRecord )
select       FROMNO  , left(ToNo,14), CallDate,	LEFT( ConnectTime,4) ,	
	 dbo.fn_calculateDurationTBR(duration, minDuration,MinIncrement)  ,  right(CAST(RecordID as varchar(10)),5),	 creditCardNo , right(CreditCardExp,2) +left(CreditCardExp,2) ,
             right( dbo.fn_CalculateChargeAmt(firstMinute,nextMinute,connectFee,    dbo.fn_calculateDuration(duration, minDuration,MinIncrement) ,   callType, TotalSurcharge, minDuration),5) ,
	settlementCode +  (CASE  CreditCardtype  
				WHEN  '1' THEN   'M' 
				WHEN '2' THEN  'V'
				 WHEN '3' THEN  'A' 
				WHEN '4' THEN  'S'
			 END )  	 + FromState + ToState + CASE WHEN  CreditcardZip <> ''  THEN  left(CreditcardZip,5)  ELSE  '     '   End + CreditCardCVV , tblFacility.libraryCode ,
			  CASE WHEN MethodOfRecord = '04' Then '1'  ELSE '2'  End 
	From  tblcallsBilled   With (nolock) , tblFacility with(nolock) 

	WHERE   tblFacility.facilityID = tblcallsbilled.facilityID AND
		   (billType  =  '03'  or   billType  =  '05' )    and 
		  CallDate = @Connectdate  and ( complete  is null  or   complete ='0'  or  complete ='1'  ) 
		   and convert (int,duration ) > 0 --  and CAST(ResponseCode as int) > 100  
		    and tono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0) 
	EXEC p_writeTBRRecords  @Connectdate
	--select * from   ##tblTBRtemp
	Drop table  ##tblTBRtemp
