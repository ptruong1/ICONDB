

CREATE PROCEDURE [dbo].[p_export_billing_record_TBR_temp]
@Connectdate  varchar(6) 
 AS
SET NOCOUNT ON
EXEC p_create_tblTBRTemp
INSERT INTO ##tblTBRtemp( FromNo ,    ToNo ,         ConnectDate,ConnectTime, CallDuration, sequenceNo,  CCNo ,CCExp, 
                                    RatedCharge,filler, lib,MethodOfRecord )
select       CASE  isnull( DID,'')     when '' then  FROMNO Else DID END , left(ToNo,14), CallDate,	LEFT( ConnectTime,4) ,	
	 dbo.fn_calculateDurationTBR(duration, minDuration,MinIncrement)  , right(projectcode,5),	 creditCardNo , right(CreditCardExp,2) +left(CreditCardExp,2) ,
             right( dbo.fn_CalculateChargeAmt(firstMinute,nextMinute,connectFee,    dbo.fn_calculateDuration(duration, minDuration,MinIncrement) ,   callType, TotalSurcharge, minDuration),5) ,
	settlementCode +  (CASE  CreditCardtype  
				WHEN  '1' THEN   'M' 
				WHEN '2' THEN  'V'
				 WHEN '3' THEN  'A' 
				WHEN '4' THEN  'S'
			 END )  	 + FromState + ToState + CASE WHEN  CreditcardZip <> ''  THEN  left(CreditcardZip,5)  ELSE  '     '   End + CreditCardCVV , tblFacility.libraryCode ,
			  CASE WHEN MethodOfRecord = '04' Then '1'  ELSE '2'  End 
	From  tblcallsBilled   With (nolock) , tblFacility with(nolock) 

	WHERE  errorCode =0  and  tblcallsBilled.AgentID = 225 and tblFacility.facilityID = tblcallsbilled.facilityID AND
		   (billType  =  '03'  or   billType  =  '05' )    and 
		  left(CallDate,4) = @Connectdate   
		   and convert (int,duration ) > 0 
		    and tono not in (select authNo from  tblofficeANI with(nolock)  where  Billabe =0) and tblFacility.FacilityID not in (2, 29)
	EXEC p_writeTBRRecords  @Connectdate
	--select * from   ##tblTBRtemp
	Drop table  ##tblTBRtemp

