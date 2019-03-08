
CREATE PROCEDURE [dbo].[p_update_missing_calls_Oncall_new] 
AS

Set Nocount on

declare @calldate varchar(10) ,   @duration	int, @projectcode varchar(6),@billtype char(2)  , @RecordID bigint  , @callRevenue  numeric(6,2) ,
 @tono  char(10) , @AccountNo varchar(18), @firstMin  Numeric(6,2) , @NextMin Numeric(6,2) ,  @connectFee  Numeric(6,2) , @callType  char(2)
SET @callRevenue  =0
SET @calldate = right(convert(varchar(10),getdate(),112),6)
SET  @duration	=0
select top 1  @RecordID = RecordID, @tono = tono, @AccountNo = CreditcardNo,
	 @callRevenue  =  dbo.fn_CalculateCallRevenue( firstMinute  ,nextMinute ,connectFee  ,duration ,CallType  ,TotalSurcharge  ,minDuration )   from tblOncalls
  where  	 tblOncalls.errorcode='0' and  
	datediff(hh,recorddate,getdate()) >1  and 
	calldate = @calldate and tblOncalls.RecordID  not in (select RecordID from tblcallsbilled with(nolock) where calldate=@calldate)
	and duration > 5 and  tono not like '888%'


if(@RecordID>0) 
Begin
	Insert tblcallsbilled (RecordID , Calldate ,ConnectTime, FromNo,ToNo , BillToNo ,  MethodOfRecord, billType, CallType, FromState, FromCity,ToState, ToCity , CreditCardType, CreditCardNo , CreditCardExp,
	 CreditCardZip, CreditCardCVV ,CallPeriod ,LibraryCode, Indicator19, SettlementCode, ProjectCode, complete ,errorCode ,ratePlanID ,firstMinute,  nextMinute  ,
	 connectFee ,  minDuration, RateClass, userName ,RecordDate,TotalSurcharge, duration  ,Dberror ,ResponseCode, AuthName ,AgentID, RecordFile ,MinIncrement, FolderDate,
	 Channel ,InmateID,  PIN  , FacilityID , InRecordFile, CallRevenue)
	select  RecordID , Calldate ,ConnectTime, FromNo, ToNo , BillToNo ,  MethodOfRecord, billType, CallType, FromState, FromCity,ToState, ToCity , CreditCardType, CreditCardNo , CreditCardExp,
	 CreditCardZip, CreditCardCVV ,CallPeriod ,LibraryCode, Indicator19, SettlementCode, ProjectCode, complete ,errorCode ,ratePlanID ,firstMinute,  nextMinute  ,
	 connectFee ,  minDuration, RateClass, userName ,RecordDate,TotalSurcharge, duration  ,Dberror ,ResponseCode, AuthName ,AgentID, RecordFile ,MinIncrement, FolderDate,
	 Channel ,InmateID,  PIN  , FacilityID , InRecordFile , @callRevenue   from tblOncalls  with(nolock) 
	where Errorcode='0' and RecordID =  @RecordID
	
	
	If( @billtype ='10')
	 Begin
		
		Update  tblPrepaid   Set balance = balance - @callRevenue where  phoneno = @tono
		--Update  tblPrepaid   Set balance =0 where  phoneno = @tono and balance <0 
	 End 
	else If( @billtype ='07')
	 Begin
		Update  tblDebit   Set balance = balance - @callRevenue where  AccountNo = @AccountNo 
		Update  tblDebit    Set balance =0 where AccountNo = @AccountNo  and balance <0 
	 End 
End
--select @RecordID
