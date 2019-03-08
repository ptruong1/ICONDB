
CREATE PROCEDURE [dbo].[p_update_billedCall_per_date]
@RecordID   bigint,
 @Calldate  char(6), 
@ConnectTime  char(6),
 @FromNo  char(10),
 @ToNo  varchar(18) , 
 @BillToNo  varchar(10) ,  
@MethodOfRecord  char(2), 
@billType  char(2),
@CallType  char(2), 
@FromState  char(2),
@FromCity 	char(10),  
@ToState  char(2), 
@ToCity 	char(10) ,   
@CreditCardType	varchar(1), 
@CreditCardNo		varchar(16)  ,  
@CreditCardExp		varchar(4), 
@CreditCardZip		varchar(5) ,
@CreditCardCVV	varchar(4), 
@CallPeriod		varchar(1) ,
@LibraryCode		varchar(2),
@Indicator19		varchar(1), 
@SettlementCode	varchar(1), 
@projectCode		VARCHAR(6),
@complete 		char(1),
@errorCode		tinyint ,
@ratePlanID		varchar(5), 
@firstMinute		numeric(6,4),  
@nextMinute		numeric(6,4),    
@connectFee 		numeric(6,4),  
@minDuration		tinyint, 
@RateClass		char(1), 
@userName		varchar(20) ,  
@RecordDate  		datetime    ,
@totalSurcharge	numeric(6,2),  
@duration		int  ,  
@Dberror		varchar(1), 
@ResponseCode	varchar(3),
@Pif 			numeric(4,2), 
@NSF			numeric(4,2),    
@PSC 			numeric(4,2),
@AgentID		varchar(5),   
@RecordFile 		varchar(20) ,        
@MinIncrement 		tinyint,
@FolderDate		varchar(8), 
@Channel		int, 
@InmateID 		varchar(12),     
@CallRevenue		numeric(6,2), 
@PIN 			varchar(12),         
@FacilityID		int,
@InRecordFile  		varchar(20) ,      
@LocationId		int,  
@DivisionId		int
AS


If(select count(*)  from tblcallsbilled with(nolock) where  RecordID = @RecordID and calldate =@callDate)  = 0
 Begin
	Insert tblcallsbilled( RecordID, Calldate, ConnectTime, FromNo , ToNo ,  BillToNo ,  MethodOfRecord, billType, CallType, FromState, FromCity ,  ToState, ToCity  ,   CreditCardType, CreditCardNo  ,  CreditCardExp, CreditCardZip ,
	CreditCardCVV, CallPeriod ,LibraryCode, Indicator19, SettlementCode, ProjectCode, complete ,errorCode ,ratePlanID, firstMinute,  nextMinute,   connectFee ,  minDuration, RateClass, userName ,  RecordDate      ,totalSurcharge,
	 duration  ,  Dberror, ResponseCode,   Pif ,   NSF,    PSC ,  AgentID,    RecordFile  ,         MinIncrement ,FolderDate, Channel, InmateID ,     CallRevenue, PIN ,         FacilityID,
	 InRecordFile   ,      LocationId,  DivisionId ) 
	Values (@RecordID, @Calldate  ,@ConnectTime  , @FromNo  , @ToNo, @BillToNo  ,@MethodOfRecord  ,@billType  ,@CallType  ,@FromState  ,@FromCity 	,@ToState  ,@ToCity ,@CreditCardType,@CreditCardNo,
	@CreditCardExp,@CreditCardZip	,@CreditCardCVV,@CallPeriod	,@LibraryCode	,@Indicator19,@SettlementCode	,@projectCode, @complete,@errorCode	,@ratePlanID,@firstMinute,@nextMinute,@connectFee ,
	@minDuration	,@RateClass	,@userName	,@RecordDate	,@totalSurcharge,@duration,@Dberror,@ResponseCode,@Pif ,@NSF,@PSC 	,@AgentID,@RecordFile	,    @MinIncrement ,@FolderDate	,@Channel	,@InmateID 	,@CallRevenue	,
	@PIN 	,   @FacilityID	,@InRecordFile  	,@LocationId,@DivisionId)
 	if(@billtype = '10')
 	 begin
		Update  tblprepaid set balance = balance - @CallRevenue where  phoneno = @ToNo
	 End
	else if(@billtype = '07')
	 begin
		Update  tblDebit set balance = balance - @CallRevenue where  AccountNo = @CreditCardNo
	 End
		
 End
Else 
 Begin
	if(@billtype = '03' or @billtype ='05') 
	 Begin
		Update  tblcallsbilled set  complete = @complete  where  RecordId = @recordID  and calldate =@calldate
  	 End

 End

