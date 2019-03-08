
CREATE PROCEDURE [dbo].[p_prepaid_payment_by_phone_v1]
@AccountNo  varchar(12),
@PurchaseAmount    numeric(7,2) ,  
@Fee	numeric(7,2) ,  
@Tax	numeric(7,2) , 
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccZip		varchar(5),
@ccCVV	VARCHAR(4)


AS
SET NoCount ON;
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @facilityID int,@NewBalance	numeric(7,2);
Declare @return_value int, @nextID bigint, @ID bigint, @tblTransactionLogs nvarchar(32), @tblpurchase nvarchar(32), @tblPrepaidPayments nvarchar(32) ;

SET  @authAmount = @PurchaseAmount + @Fee+ @Tax;
SET  @LastBalance  = 0;
if(len(@AccountNo) =11 and left(@AccountNo,1) in ('1','0'))   -- Edit on 12/2/2016 to detect 1 or 0 infront 
 Begin
	SET @AccountNo = right(@AccountNo,10) ;
 End

EXEC   @return_value = p_create_nextID 'tblTransactionLogs', @nextID   OUTPUT
       set           @ID = @nextID ;  
INSERT  tblTransactionLogs (TransactionID, AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
			Values(@ID, '', @ccExp, @ccZip , getdate() ,'010', @authAmount ,@AccountNo );

--INSERT  tblTransactionLogs ( AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
--			Values(@ccNo, @ccExp, @ccZip , getdate() ,'010', @authAmount ,@AccountNo );	

SELECT  @LastBalance =  balance  , @EndUserID = EnduserID,@facilityID =FacilityID   From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

	EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;  
	Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), 'ByPhone');

	--Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), 'ByPhone');

	SET @purchaseID = @ID;

	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @Fee);
	else
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @Fee);

	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);

	If (@Tax >0) 
	 begin
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values(@purchaseID, 1, 4, @Tax);
			EXEC [p_CalculatePrepaidTax] @PurchaseAmount ,@AccountNo,@Tax  ,@purchaseID ;
	 end

	  EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
       set           @ID = @nextID ;  
	INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  PaymentDate, PurchaseNo,LastBalance  )
				        Values(@ID, @AccountNo, @FacilityID, @authAmount , 1,left( @ccNo,4) + "***" + right( @ccNo,4) , @ccExp,@ccZip, @ccCVV, getdate(), @purchaseID, @LastBalance);
	
	--INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  PaymentDate, PurchaseNo,LastBalance  )
	--			        Values(@AccountNo, @FacilityID, @authAmount , 1,left( @ccNo,4) + "***" + right( @ccNo,4) , @ccExp,@ccZip, @ccCVV, getdate(), @purchaseID, @LastBalance);
	

Update  tblprepaid set Balance = Balance + @PurchaseAmount, [status] =1 , ModifyDate=getdate()  where  phoneNo =  @AccountNo ;

SET    @NewBalance =  @LastBalance + @PurchaseAmount ;

Select @AccountNo as AccountNo,  @NewBalance as Balance , 1 as Success, '010' as ResponseCode


