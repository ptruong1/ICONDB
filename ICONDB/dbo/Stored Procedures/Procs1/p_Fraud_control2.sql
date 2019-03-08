CREATE PROCEDURE [dbo].[p_Fraud_control2]
@MerchantProfileID	varchar(15),
@CCNO	varchar(19),
@PhoneNo	varchar(16),
@transType	tinyint,
@deviceID	varchar(15) OUTPUT,
@LoginID	varchar(15) OUTPUT,
@password	varchar(15) OUTPUT,
@pin		varchar(5) OUTPUT,
@sourceKey	varchar(40) OUTPUT
 AS

set @LoginID =''

select @deviceID=deviceID,@LoginID= Operator,  @password=OpPass, @pin= USpayPIN, @sourceKey=sourceKey  from tblMerchantProfile with(nolock)  where MerchantProfileID= @MerchantProfileID
if (@LoginID ='') 	return -1

If(@transType =1)
 Begin
	
	if(select count(*) from tblFraud    where AccountNo = @CCNO) >0
		return -2
	
	if ((select count(*) from tblBCResponse    where cNum= @CCNO and transType=1 and datediff(d,transDate ,getdate()) =0 and statusMess <>'APPROVED' )  > 3  )
		return -2
	if ((select count(*) from tblBCResponse    where cNum= @CCNO and transType=2 and datediff(d,transDate ,getdate()) <7  and statusMess <>'APPROVED' )  > 2  )
		return -2
	
	--select 1
 End
else
 Begin
	return 0
 end
--if ((select count(*) from tblBCResponse   with(nolock)  where cNum= @CCNO and transType=2 and datediff(d,transDate ,getdate())  < 30  and statusMess  = 'APPROVED' )  > 10   and @transType =1)
	--return -2

declare @AccessCtr bit ,@AmountCtr bit, @ProductCtr bit, @HourlyCnt smallint,  @DailyCnt smallint , @MonthlyCnt smallint,@WeeklyCnt  smallint
SET @AccessCtr =0
SET @AmountCtr=0
SET @ProductCtr =0
SET @HourlyCnt =0
SET @DailyCnt =0
SET @WeeklyCnt =0
SET  @MonthlyCnt =0

select  @AccessCtr=  AccessCtr , @AmountCtr=  AmountCtr , @ProductCtr = ProductCtr  from tblFraudControl with(nolock) where MerchantProfileID= @MerchantProfileID

if(@AccessCtr =1)
 begin
	select @HourlyCnt =isnull( Hourly,0),  @DailyCnt =isnull(Daily,0) ,@WeeklyCnt =isnull(weekly,0),  @MonthlyCnt = isnull(Monthly,0)  from tblFraudControlByAccess  with(nolock)  where MerchantProfileID= @MerchantProfileID
	if(@HourlyCnt > 0)
		if (select count(*) from tblBCResponse where cNum= @CCNO and transType=1 and datediff(mi,transDate ,getdate()) <=60  and statusMess = 'APPROVED' )  > @HourlyCnt 
			return -2
	if(@DailyCnt > 0)
		if (select count(*) from tblBCResponse where cNum= @CCNO and transType=1 and datediff(d,transDate ,getdate()) =0  and statusMess = 'APPROVED' )  > @DailyCnt 
			return -2
	if(@WeeklyCnt > 0)
		if (select count(*) from tblBCResponse where cNum= @CCNO and transType=1 and datediff(d,transDate ,getdate()) <=7  and statusMess = 'APPROVED' )  > @WeeklyCnt 
			return -2
	if(@MonthlyCnt > 0)
		if (select count(*) from tblBCResponse where cNum= @CCNO and transType=1 and datediff(d,transDate ,getdate()) <=30  and statusMess = 'APPROVED' )  >@MonthlyCnt 
			return -2
 end

if(@AmountCtr=1)
 begin
	SET @HourlyCnt =0
	SET @DailyCnt =0
	SET @WeeklyCnt =0
	SET  @MonthlyCnt =0
	select @HourlyCnt =isnull( HourlyAmt,0),  @DailyCnt =isnull(DailyAmt,0) ,@WeeklyCnt =isnull(weeklyAmt,0),  @MonthlyCnt =isnull( MonthlyAmt,0)  from tblFraudControlByAmount  with(nolock)  where MerchantProfileID= @MerchantProfileID
	if(@HourlyCnt > 0)
		if (select sum(Amount) from tblBCResponse where cNum= @CCNO and transType=2 and datediff(mi,transDate ,getdate()) <=60  and statusMess = 'APPROVED' )  > @HourlyCnt    
			return -2
	if(@DailyCnt > 0)
		if (select sum(Amount) from tblBCResponse where cNum= @CCNO and transType=2 and datediff(d,transDate ,getdate()) =0  and statusMess = 'APPROVED' )  > @DailyCnt   
			return -2
	if(@WeeklyCnt > 0)
		if (select sum(Amount) from tblBCResponse where cNum= @CCNO and transType=2 and datediff(d,transDate ,getdate()) <=7  and statusMess = 'APPROVED' )  > @WeeklyCnt  
			return -2
	if(@MonthlyCnt > 0)
		if (select sum(Amount) from tblBCResponse where cNum= @CCNO and transType=2 and datediff(d,transDate ,getdate()) <=30  and statusMess = 'APPROVED' )  >@MonthlyCnt  
			return -2
 end
