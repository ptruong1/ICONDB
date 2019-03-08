CREATE PROCEDURE [dbo].[p_debit_print_payment_API]
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
SET NoCount ON
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @NewBalance  numeric(7,2), @AccountNo  varchar(12), @i  int
Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32),@tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32), @tblTransactionLogs nvarchar(32) ;

SET  @authAmount = @PurchaseAmount + @FeeAndTax

SET @AccountNo = ''
  EXEC   @return_value = p_create_nextID 'tblTransactionLogs', @nextID   OUTPUT
       set           @ID = @nextID ;  
INSERT  tblTransactionLogs (TransactionID, AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
			Values(@ID, @ccNo, @ccExp, @ccZip , getdate() ,@ReplyCode, @authAmount ,@AccountNo )	


--select @LastBalance
If(@ReplyCode = '010'  or @ReplyCode = '000'  )   
 BEGIN
  EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;  
	Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @UserName)
	SET @purchaseID =@ID
	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax)
	else
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax)

	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount)

		EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT
       set           @ID = @nextID ; 
	INSERT INTO tblDebitPayments(paymentID, AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID, @AccountNo, @FacilityID, '0', @authAmount , @PaymentTypeID, @ccNo, @ccExp,@ccZip, @ccCVV,@UserName, getdate(), @purchaseID, 0)

	  ----Create new Debit
	
	exec p_get_new_AccountNo  @AccountNo  OUTPUT
	set @i  = 1
	while @i = 1
	Begin
		select  @i = count(*) from tblDebit where Accountno = @AccountNo
		If  (@i > 0 ) 
		 Begin
			exec p_get_new_AccountNo  @AccountNo  OUTPUT
			SET @i = 1
		 end
	end 
	 EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
       set           @ID = @nextID ;   
	INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,inmateID ,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
	VALUES (@ID, @AccountNo ,@facilityID,'0', getdate(), @PurchaseAmount, @PurchaseAmount,1, 'Process by Kios', @UserName)	
	

	SET  @NewBalance =   @PurchaseAmount
 END

Else	SET    @NewBalance = 0

Select  '000' as AuthCode,@AccountNo as AccountNumber,  @NewBalance  as AccountBalance

--AS
--SET NoCount ON
--declare  @purchaseID bigint, @authAmount	numeric(7,2),   @NewBalance  numeric(7,2), @AccountNo  varchar(12), @i  int
--SET  @authAmount = @PurchaseAmount + @FeeAndTax

--SET @AccountNo = ''

--INSERT  tblTransactionLogs ( AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
--			Values(@ccNo, @ccExp, @ccZip , getdate() ,@ReplyCode, @authAmount ,@AccountNo )	


----select @LastBalance
--If(@ReplyCode = '010'  or @ReplyCode = '000'  )   
-- BEGIN
--	Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @UserName)
--	SET @purchaseID =SCOPE_IDENTITY()
--	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
--		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax)
--	else
--		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax)

--	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount)


--	INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
--					        Values(@AccountNo, @FacilityID, '0', @authAmount , @PaymentTypeID, @ccNo, @ccExp,@ccZip, @ccCVV,@UserName, getdate(), @purchaseID, 0)

--	  ----Create new Debit
	
--	exec p_get_new_AccountNo  @AccountNo  OUTPUT
--	set @i  = 1
--	while @i = 1
--	Begin
--		select  @i = count(*) from tblDebit where Accountno = @AccountNo
--		If  (@i > 0 ) 
--		 Begin
--			exec p_get_new_AccountNo  @AccountNo  OUTPUT
--			SET @i = 1
--		 end
--	end 
	
--	INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,inmateID ,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
--	VALUES (@AccountNo ,@facilityID,'0', getdate(), @PurchaseAmount, @PurchaseAmount,1, 'Process by Kios', @UserName)	
	

--	SET  @NewBalance =   @PurchaseAmount
-- END

--Else	SET    @NewBalance = 0

--Select  '000' as AuthCode,@AccountNo as AccountNumber,  @NewBalance  as AccountBalance

