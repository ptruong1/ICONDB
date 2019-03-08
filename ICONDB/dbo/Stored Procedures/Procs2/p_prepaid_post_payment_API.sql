CREATE PROCEDURE [dbo].[p_prepaid_post_payment_API]
@AccountNo  varchar(12),
@facilityID int,
@PurchaseAmount    numeric(7,2) ,  
@FeeAndTax	numeric(7,2) ,  
@paymentTypeID tinyint , 
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccZip		varchar(5),
@ccCVV	VARCHAR(4),
@ReplyCode	varchar(3),
@UserName	VARCHAR(20)

AS
SET NoCount ON;
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @NewBalance  numeric(7,2);
Declare @return_value int, @nextID bigint, @ID bigint,  @tblpurchase nvarchar(32), @tblPrepaidPayments nvarchar(32) ;
SET  @authAmount = @PurchaseAmount + @FeeAndTax;
SET  @LastBalance  = 0;
SET @EndUserID =0;
SET @FeeAndTax = ISNULL(@FeeAndTax,0)

--INSERT  tblTransactionLogs ( AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
			--Values(@ccNo, @ccExp, @ccZip , getdate() ,@ReplyCode, @authAmount ,@AccountNo )	
SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo 

If(@ReplyCode = '010'   or @ReplyCode ='000' )   
 BEGIN
  EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;  
	Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @UserName);
	SET @purchaseID =@ID;
	If ((select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo )  =0) and @FeeAndTax >0
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax);
	else
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax);

	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);


    EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
       set           @ID = @nextID ;
	INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  PaymentDate, PurchaseNo,LastBalance ,UserName  )
				        Values(@ID, @AccountNo, @FacilityID, @authAmount , @PaymentTypeID, @ccNo, @ccExp,@ccZip, @ccCVV, getdate(), @purchaseID, @LastBalance,@UserName)
	If(@EnduserID = 0)
	 begin
		EXEC p_register_new_prepaid_Account3
								@FacilityID,	
								@AccountNo ,
								'',
								'',
								'', 
								'',
								1,
								'USA',
								'',
								'',
								'tpKiosk@email.com',
								@AccountNo,
								@AccountNo,
								'NA',
								99,
								0,
								''
	End
	UPDATE tblPrepaid  Set Balance = Balance + @PurchaseAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo
	SET  @NewBalance =  @LastBalance +  @PurchaseAmount
 END

Else
	SET    @NewBalance =  @LastBalance 

Select  '000' as AuthCode, @AccountNo   as AccountNo ,  @NewBalance  as NewBalance


--AS
--SET NoCount ON;
--declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @NewBalance  numeric(7,2);
--SET  @authAmount = @PurchaseAmount + @FeeAndTax;
--SET  @LastBalance  = 0;
--SET @EndUserID =0;
--SET @FeeAndTax = ISNULL(@FeeAndTax,0)

----INSERT  tblTransactionLogs ( AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
--			--Values(@ccNo, @ccExp, @ccZip , getdate() ,@ReplyCode, @authAmount ,@AccountNo )	
--SELECT  @LastBalance =  balance  , @EndUserID = EnduserID  From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo 

--If(@ReplyCode = '010'   or @ReplyCode ='000' )   
-- BEGIN
--	Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @UserName);
--	SET @purchaseID =SCOPE_IDENTITY();
--	If ((select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo )  =0) and @FeeAndTax >0
--		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax);
--	else
--		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax);

--	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);



--	INSERT INTO tblPrepaidPayments(AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  PaymentDate, PurchaseNo,LastBalance ,UserName  )
--				        Values(@AccountNo, @FacilityID, @authAmount , @PaymentTypeID, @ccNo, @ccExp,@ccZip, @ccCVV, getdate(), @purchaseID, @LastBalance,@UserName)
--	If(@EnduserID = 0)
--	 begin
--		EXEC p_register_new_prepaid_Account3
--								@FacilityID,	
--								@AccountNo ,
--								'',
--								'',
--								'', 
--								'',
--								1,
--								'USA',
--								'',
--								'',
--								'tpKiosk@email.com',
--								@AccountNo,
--								@AccountNo,
--								'NA',
--								99,
--								0,
--								''
--	End
--	UPDATE tblPrepaid  Set Balance = Balance + @PurchaseAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate(), status=1  where PhoneNo =@AccountNo
--	SET  @NewBalance =  @LastBalance +  @PurchaseAmount
-- END

--Else
--	SET    @NewBalance =  @LastBalance 

--Select  '000' as AuthCode, @AccountNo   as AccountNo ,  @NewBalance  as NewBalance

