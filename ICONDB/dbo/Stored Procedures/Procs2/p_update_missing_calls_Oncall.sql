
CREATE PROCEDURE [dbo].[p_update_missing_calls_Oncall] AS

Set Nocount on

declare @calldate varchar(10) ,   @duration	int, @projectcode varchar(6),@billtype char(2)  , @RecordID bigint  , @callRevenue  numeric(6,2) , @tono  char(10) , @AccountNo varchar(18)
SET @callRevenue  =0
SET @calldate = right(convert(varchar(10),getdate(),112),6)
SET  @duration	=0
select top 1  @RecordID =  tblOutboundCalls.OpSeqNo  from tblOutboundCalls,tblOncalls
  where  tblOncalls.RecordID = tblOutboundCalls.OpSeqNo and  
	 tblOncalls.calldate = tblOutboundCalls.calldate and 
	 tblOutboundCalls.Duration >30  and 
	 tblOncalls.errorcode='0' and  
	  (tblOncalls.billtype ='01' or tblOncalls.billtype ='10'  or tblOncalls.billtype ='07'  or tblOncalls.billtype ='05' or tblOncalls.billtype='03'  )  and  datediff(mi,tblOutboundCalls.recorddate,getdate()) >20  and
	tblOncalls.calldate = @calldate and tblOncalls.RecordID  not in (select RecordID from tblcallsbilled with(nolock) where calldate=@calldate)

select @duration = duration, @billtype =billtype   from tblOutboundCalls with(nolock) where OpSeqNo = @RecordID and duration > 30

if(@duration >30) 
Begin
	Insert tblcallsbilled (RecordID , Calldate ,ConnectTime, FromNo,ToNo , BillToNo ,  MethodOfRecord, billType, CallType, FromState, FromCity,ToState, ToCity , CreditCardType, CreditCardNo , CreditCardExp,
	 CreditCardZip, CreditCardCVV ,CallPeriod ,LibraryCode, Indicator19, SettlementCode, ProjectCode, complete ,errorCode ,ratePlanID ,firstMinute,  nextMinute  ,
	 connectFee ,  minDuration, RateClass, userName ,RecordDate,TotalSurcharge, duration  ,Dberror ,ResponseCode, AuthName ,AgentID, RecordFile ,MinIncrement, FolderDate,
	 Channel ,InmateID,  PIN  , FacilityID , InRecordFile, CallRevenue)
	select  RecordID , Calldate ,ConnectTime, FromNo, ToNo , BillToNo ,  MethodOfRecord, billType, CallType, FromState, FromCity,ToState, ToCity , CreditCardType, CreditCardNo , CreditCardExp,
	 CreditCardZip, CreditCardCVV ,CallPeriod ,LibraryCode, Indicator19, SettlementCode, ProjectCode, complete ,errorCode ,ratePlanID ,firstMinute,  nextMinute  ,
	 connectFee ,  minDuration, RateClass, userName ,RecordDate,TotalSurcharge, @duration  ,Dberror ,ResponseCode, AuthName ,AgentID, RecordFile ,MinIncrement, FolderDate,
	 Channel ,InmateID,  PIN  , FacilityID , InRecordFile , dbo.fn_CalculateCallRevenue( firstMinute  ,nextMinute ,connectFee  ,@duration ,CallType  ,TotalSurcharge  ,minDuration )  from tblOncalls C with(nolock) 
	where Errorcode='0' and RecordID =  @RecordID
	
	Select  @callRevenue  = CallRevenue, @tono = tono, @AccountNo = CreditcardNo  From  tblcallsbilled where RecordID = @RecordID
	If( @billtype ='10')
	 Begin
		Update  tblPrepaid   Set balance = balance - @callRevenue where  phoneno = @tono
		Update  tblPrepaid   Set balance =0 where  phoneno = @tono and balance <0 
	 End 
	else If( @billtype ='07')
	 Begin
		Update  tblDebit   Set balance = balance - @callRevenue where  AccountNo = @AccountNo 
		Update  tblDebit    Set balance =0 where AccountNo = @AccountNo  and balance <0 
	 End 
End
--select @RecordID
