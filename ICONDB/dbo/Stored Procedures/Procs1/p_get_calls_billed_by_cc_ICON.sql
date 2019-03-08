
CREATE PROCEDURE [dbo].[p_get_calls_billed_by_cc_ICON]
@FromNo  varchar(13)  OUTPUT,
@ToNo varchar(20) OUTPUT, 
@creditCardNo varchar(18)  OUTPUT, 
@CreditCardExp  varchar(4) OUTPUT ,
@creditcardcvv  varchar(4) OUTPUT, 
@CreditcardZip varchar(5) OUTPUT, 
@callCharge  numeric(5,2) OUTPUT,
@calldate	char(6)  OUTPUT,
@connecttime	char(6)	OUTPUT,
@projectCode   char(6)	OUTPUT
AS
Declare  @RecordID bigint
SET @FromNo='';
SET @ToNo ='';
SET  @creditCardNo=''
SET  @CreditCardExp =''
SET  @creditcardcvv =''
SET  @CreditcardZip =''
SET  @callCharge =0
SET  @RecordID =0

select  top 1  @FromNo=     FromNo, 
		@ToNo= CASE WHEN  Substring(ToNo,1,3)  ='011'  THEN SUBSTRING(ToNo,4,10)  ELSE  left(ToNo,10) END,
		 @creditCardNo = creditCardNo ,
		@CreditCardExp=  CreditCardExp,
		@creditcardcvv = creditcardcvv, 
		@CreditcardZip= CreditcardZip,
		 @callCharge = CallRevenue ,
		@calldate = calldate,
		@connecttime = connecttime,
	 	@projectCode =projectCode
			 
	From  tblcallsbilled   With (nolock)
	WHERE  --errorCode =0  and 
		   (billType  =  '03'  or   billType  =  '05' )    and 
		  complete is null    and duration > 0  and datediff(d,RecordDate,getdate()) < 60  and  projectCode <> ''
		  and creditCardNo not in (select ccNo from [Tecodata].[dbo].[tblOfficeCard])
		  
 IF( LEN(@creditCardNo) >16)
			set @creditCardNo = LEFT(@creditCardNo,16);
 IF( LEN(@creditCardNo) <13)
		   set @creditCardNo = '';		  
SET  @FromNo = '100' + @FromNo
SET  @ToNo  = cast( len(@tono) as varchar(2)) + '0'  + @toNo
SET  @creditCardNo = cast( len (@creditCardNo) as varchar(2)) + @creditCardNo
SET @callCharge = @callCharge + 0.5
update   tblcallsbilled   SET  complete = '1'  where  projectcode = @projectcode and  calldate =  @calldate and  connecttime = @connecttime
