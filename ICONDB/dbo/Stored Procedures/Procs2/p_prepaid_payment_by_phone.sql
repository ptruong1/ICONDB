
CREATE PROCEDURE [dbo].[p_prepaid_payment_by_phone]
@AccountNo  varchar(12),
@PurchaseAmount    numeric(7,2) ,  
@FeeAndTax	numeric(7,2) ,  
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccZip		varchar(5),
@ccCVV	VARCHAR(4)


AS
SET NoCount ON;
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @facilityID int,@NewBalance	numeric(7,2), @nextID bigint;

SET  @authAmount = @PurchaseAmount + @FeeAndTax;
SET  @LastBalance  = 0;
if(len(@AccountNo) =11 and left(@AccountNo,1) in ('1','0'))   -- Edit on 12/2/2016 to detect 1 or 0 infront 
 Begin
	SET @AccountNo = right(@AccountNo,10) ;
 End


INSERT  tblTransactionLogs ( AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
			Values(@ccNo, @ccExp, @ccZip , getdate() ,'010', @authAmount ,@AccountNo );	
SELECT  @LastBalance =  balance  , @EndUserID = EnduserID,@facilityID =FacilityID   From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;


	Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), 'ByPhone');
	SET @purchaseID =SCOPE_IDENTITY();
	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax);
	else
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax);

	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);


	 EXEC    p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
     

	INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  PaymentDate, PurchaseNo,LastBalance  )
				        Values(@nextID, @AccountNo, @FacilityID, @authAmount , 1, left( @ccNo,4) + "***" + right( @ccNo,4) , @ccExp,@ccZip, @ccCVV, getdate(), @purchaseID, @LastBalance);
	

Update  tblprepaid set Balance = Balance + @PurchaseAmount, [status] =1 , ModifyDate=getdate()  where  phoneNo =  @AccountNo ;

SET    @NewBalance =  @LastBalance + @PurchaseAmount ;

Select @AccountNo as AccountNo,  @NewBalance as Balance , 1 as Success, '010' as ResponseCode



