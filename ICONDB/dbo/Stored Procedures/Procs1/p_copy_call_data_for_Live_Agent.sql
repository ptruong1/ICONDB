-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_copy_call_data_for_Live_Agent]
AS

BEGIN
	

Insert tblcallsbilled (recordID, OpSeqNo, Calldate, ConnectTime ,FromNo  ,   ToNo    , BillToNo ,  MethodOfRecord, billType, CallType ,FromState, FromCity  , ToState, ToCity,
     CreditCardType, CreditCardNo  ,       CreditCardExp ,CreditCardZip, CreditCardCVV, CallPeriod, LibraryCode, complete, errorCode ,ratePlanID,
	  firstMinute ,nextMinute  ,  connectFee ,minDuration, RateClass, userName ,     RecordDate  ,TotalSurcharge , duration,ConnectDate, Dberror ,
	  ResponseCode,Pif   ,    NSF   ,  PSC , NIF  , BDf   , RAF ,   BSF   ,  AgentID, MinIncrement, CallRevenue )
select 0, OpSeqNo, Calldate, ConnectTime ,FromNo  ,   ToNo    , BillToNo ,  MethodOfRecord, (CASE billType when '07' then '05' else billtype end), CallType ,FromState, FromCity  , ToState, ToCity,
     CreditCardType, CreditCardNo  ,       CreditCardExp ,CreditCardZip, CreditCardCVV, CallPeriod, LibraryCode, complete, errorCode ,ratePlanID,
	  firstMinute ,nextMinute  ,  connectFee ,minDuration, RateClass, userName ,     RecordDate  ,TotalSurcharge , duration,ConnectDate, Dberror ,
	  ResponseCode,Pif   ,    NSF   ,  PSC , NIF  , BDf   , RAF ,   BSF   ,  AgentID, MinIncrement , 
	   dbo.fn_CalculateCallRevenue_v2(firstMinute  ,nextMinute ,connectFee ,[dbo].[fn_calculateBillableTime](duration,minduration,MinIncrement) ,callType  ,TotalSurcharge)
	   from [172.20.30.24\bigdaddyosp].Oplegacy.dbo.tblcallsbilled where AgentID =465 and DateDiff(DAY, RecordDate ,GETDATE()) =1 and 
billtype <'13' and errorcode='0';

Update tblcallsbilled  set FacilityID = b.facilityID 
 from tblcallsbilled a, tblANIs  b where a.AgentID =465 and a.FromNo = b.ANINo and a.facilityID is null and  DateDiff(DAY, RecordDate ,GETDATE()) =1;

END

