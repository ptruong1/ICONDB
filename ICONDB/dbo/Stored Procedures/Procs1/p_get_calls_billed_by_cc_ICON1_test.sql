﻿
CREATE PROCEDURE [dbo].[p_get_calls_billed_by_cc_ICON1_test]
@FromNo  varchar(13)  OUTPUT,
@ToNo varchar(20) OUTPUT, 
@creditCardNo varchar(18)  OUTPUT, 
@CreditCardExp  varchar(4) OUTPUT ,
@creditcardcvv  varchar(4) OUTPUT, 
@CreditcardZip varchar(5) OUTPUT, 
@callCharge  numeric(5,2) OUTPUT,
@calldate	char(6)  OUTPUT,
@connecttime	char(6)	OUTPUT,
 @RecordID  bigint  OUTPUT
AS
SET nocount on ;


Declare  @AgentID int, @method char(2), @facilityID int, @transFee numeric(4,2) ,@billSTFee numeric(4,2) , @YYMM char(4),@fromState varchar(2), @toState varchar(2),
		 @ToCity varchar(10), @callType varchar(2), @billtype varchar(2);
DECLARE 	@FedTax numeric(4, 2),		@StateTax numeric(4, 2),		@LocalTax numeric(4, 2);
SET @FromNo='';
SET @ToNo ='';
SET  @creditCardNo='';
SET  @CreditCardExp ='';
SET  @creditcardcvv ='';
SET  @CreditcardZip ='';
SET  @callCharge =0;
SET  @RecordID =0;
SET  @AgentID =1;
SET @fromState ='';
SET @toState ='';
SET @toCity ='';
SET @callType='';
SET @billtype ='';
SET @FedTax =0;
SET @StateTax =0;
SET 	@LocalTax =0;
select  top 1  @FromNo=     FromNo,  @AgentID = AgentID,  @facilityID = facilityID,
		@ToNo= CASE WHEN  Substring(ToNo,1,3)  ='011'  THEN SUBSTRING(ToNo,4,10)  ELSE  left(ToNo,10) END,
		 @creditCardNo = creditCardNo ,
		@CreditCardExp=  CreditCardExp,
		@creditcardcvv = creditcardcvv, 
		@CreditcardZip= CreditcardZip,
		 @callCharge = CallRevenue ,
		@calldate = calldate,
		@connecttime = connecttime,
	 	 @RecordID =RecordID,
		 @method = MethodOfRecord,
		 @fromState = fromstate,
		 @toState = toState,
		 @callType = calltype,
		 @billtype = billType,
		 @ToCity  = ToCity
		 	 
	From  tblcallsbilled   With (nolock)
	WHERE  --errorCode =0  and 
		   (billType  =  '03'  or   billType  =  '05' )    and 
		  complete is null    and duration > 0  and datediff(d,RecordDate,getdate()) < 15 
		  and creditCardNo not in (select ccNo from [Tecodata].[dbo].[tblOfficeCard] With (nolock))
		  order by Calldate 
		  

if(@creditCardNo='')
 Begin	
	select  top 1  @FromNo=     FromNo,  @AgentID = AgentID,  @facilityID = facilityID,
		@ToNo= CASE WHEN  Substring(ToNo,1,3)  ='011'  THEN SUBSTRING(ToNo,4,10)  ELSE  left(ToNo,10) END,
		 @creditCardNo = creditCardNo ,
		@CreditCardExp=  CreditCardExp,
		@creditcardcvv = creditcardcvv, 
		@CreditcardZip= CreditcardZip,
		 @callCharge = CallRevenue ,
		@calldate = calldate,
		@connecttime = connecttime,
	 	 @RecordID =RecordID,
		 @method = MethodOfRecord,
		 @fromState = fromstate,
		 @toState = toState,
		 @callType = calltype,
		 @billtype = billType,
		 @ToCity  = ToCity	
		From  tblcallsbilled  C  With (nolock)
		where  complete in ('1','0')  and  (billType  =  '03'  or   billType  =  '05' )    and duration > 0  
		 and datediff(d,RecordDate,getdate()) < 3
		 and creditCardNo not in (select ccNo from [Tecodata].[dbo].[tblOfficeCard]  With (nolock))
		  and left(creditcardno,16) not in 	(select Cnum from TecoData.dbo.tblBCresponse R  With (nolock) where Amount >0.2 and  C.calldate = R.Calldate and C.connecttime =R.Calltime and datediff(d,transDate,getdate()) < 3  ) 		
		if( @RecordID >0)
			update  tblcallsbilled  set complete ='1', errorcode ='3'  where RecordID =  @RecordID and calldate = @calldate
		
 end
 
 IF( LEN(@creditCardNo) >16)
			set @creditCardNo = LEFT(@creditCardNo,16);
 IF( LEN(@creditCardNo) <13)
		   set @creditCardNo = '';


  ---Bill  fee

if(@creditCardNo <>'')
 Begin
	
	SET @YYMM = left(@callDate,4)
	--SET @transFee =0;
	--SET @billSTFee =0;
	select @RecordID;
	EXEC p_CalculateCallFees @facilityID ,	@creditCardNo , @YYMM, @callCharge, 	@RecordID  ,	@transFee  OUTPUT, 	@billSTFee  OUTPUT ;
	EXEC p_CalculateCallTaxes @facilityID ,@callCharge,@RecordID,@FromState ,@ToState ,@ToCity,@Calltype ,@billtype,	@toNo ,
				@FedTax = @FedTax OUTPUT,	@StateTax = @StateTax OUTPUT,	@LocalTax = @LocalTax OUTPUT;

	SET  @FromNo = '100' + @FromNo;
	SET  @ToNo  = cast( len(@tono) as varchar(2)) + '0'  + @toNo;
	SET  @creditCardNo = cast( len (@creditCardNo) as varchar(2)) + @creditCardNo;
	SET @callCharge = @callCharge +  @transFee  + @billSTFee + @FedTax + @StateTax + @LocalTax ;
	--if( @RecordID >0)
		--update  tblcallsbilled  set complete ='0', errorcode ='3'  where RecordID =  @RecordID and calldate = @calldate;
 End
else
 begin
	SET @callCharge =0;
	if(@RecordID > 0)
	    update  tblcallsbilled  set complete ='0', errorcode ='3'  where RecordID =  @RecordID and calldate = @calldate;
 end
