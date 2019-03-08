CREATE PROCEDURE [dbo].[p_debit_post_payment_API]
@InmateID	varchar(12),
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
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @NewBalance  numeric(7,2), @AccountNo  varchar(12), @i  int;
 Declare @return_value int, @nextID int, @ID int, @tblDebit nvarchar(32),@tblTransactionLogs nvarchar(32),@tblpurchase nvarchar(32),@tblDebitPayments nvarchar(32);

SET  @authAmount = @PurchaseAmount + @FeeAndTax;

SET @AccountNo = '';
SET @LastBalance =0;

-- EXEC   @return_value = p_create_nextID 'tblTransactionLogs', @nextID   OUTPUT
--       set           @ID = @nextID ;      
--INSERT  tblTransactionLogs (TransactionID ,AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
--			Values(@ID, @ccNo, @ccExp, @ccZip , getdate() ,@ReplyCode, @authAmount ,@AccountNo )	;

Select  @LastBalance = balance, @AccountNo = AccountNo from tblDebit where facilityID = @facilityID  and InmateID = @InmateID;

--select @LastBalance
If(@ReplyCode = '010'  )   
 BEGIN
     EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;    
	Insert tblpurchase(PurchaseNo  ,AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @UserName);
	SET @purchaseID =@ID;
	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax);
	else
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax);

	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);

       EXEC   @return_value = p_create_nextID 'tblDebitPayments', @nextID   OUTPUT
       set           @ID = @nextID ;     
	INSERT INTO tblDebitPayments(paymentID ,AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
					        Values(@ID, @AccountNo, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, '***' + right(@ccNo,4), @ccExp,@ccZip, @ccCVV,@UserName, getdate(), @purchaseID, @LastBalance);

	  ----Create new Debit
	If (@AccountNo = '')
	 Begin
		exec p_get_new_AccountNo  @AccountNo  OUTPUT;
		set @i  = 1;
		while @i = 1
		Begin
			select  @i = count(*) from tblDebit where Accountno = @AccountNo;
			If  (@i > 0 ) 
			 Begin
				exec p_get_new_AccountNo  @AccountNo  OUTPUT;
				SET @i = 1;
			 end
		end 
		

       EXEC   @return_value = p_create_nextID 'tblDebit', @nextID   OUTPUT
       set           @ID = @nextID ;      
		INSERT INTO [tblDebit] ([RecordID], [AccountNo],FacilityID ,inmateID ,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
		VALUES (@ID, @AccountNo ,@facilityID,@inmateID, getdate(), @PurchaseAmount, @PurchaseAmount,1, 'Process by Kios', @UserName);
		
	 End
	else
	 begin
		UPDATE tblDebit  Set Balance = Balance +  @PurchaseAmount ,  ModifyDate = getdate(), username = @userName  where AccountNo =@AccountNo;
	 end

	SET  @NewBalance =  @LastBalance +  @PurchaseAmount;
 END

Else	SET    @NewBalance =  @LastBalance ;

Select  '000' as AuthCode, @ReplyCode  as ReplyCode ,  @NewBalance  as NewBalance;


--AS
--SET NoCount ON
--declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @NewBalance  numeric(7,2), @AccountNo  varchar(12), @i  int;
--SET  @authAmount = @PurchaseAmount + @FeeAndTax;

--SET @AccountNo = '';
--SET @LastBalance =0;


--INSERT  tblTransactionLogs ( AccountNo, ExpDate , Bill_to_Zip ,TransactionTime , reasonCode,  AuthReply_amount,  phoneNo)
--			Values(@ccNo, @ccExp, @ccZip , getdate() ,@ReplyCode, @authAmount ,@AccountNo )	;

--Select  @LastBalance = balance, @AccountNo = AccountNo from tblDebit where facilityID = @facilityID  and InmateID = @InmateID;

----select @LastBalance
--If(@ReplyCode = '010'  )   
-- BEGIN
--	Insert tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @UserName);
--	SET @purchaseID =SCOPE_IDENTITY();
--	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
--		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @FeeAndTax);
--	else
--		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @FeeAndTax);

--	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);


--	INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
--					        Values(@AccountNo, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, @ccNo, @ccExp,@ccZip, @ccCVV,@UserName, getdate(), @purchaseID, @LastBalance);

--	  ----Create new Debit
--	If (@AccountNo = '')
--	 Begin
--		exec p_get_new_AccountNo  @AccountNo  OUTPUT;
--		set @i  = 1;
--		while @i = 1
--		Begin
--			select  @i = count(*) from tblDebit where Accountno = @AccountNo;
--			If  (@i > 0 ) 
--			 Begin
--				exec p_get_new_AccountNo  @AccountNo  OUTPUT;
--				SET @i = 1;
--			 end
--		end 
		
--		INSERT INTO [tblDebit] ( [AccountNo],FacilityID ,inmateID ,  [ActiveDate],  [Balance],[ReservedBalance],  [status], [Note], [UserName]) 
--		VALUES (@AccountNo ,@facilityID,@inmateID, getdate(), @PurchaseAmount, @PurchaseAmount,1, 'Process by Kios', @UserName);
		
--	 End
--	else
--	 begin
--		UPDATE tblDebit  Set Balance = Balance +  @PurchaseAmount ,  ModifyDate = getdate(), username = @userName  where AccountNo =@AccountNo;
--	 end

--	SET  @NewBalance =  @LastBalance +  @PurchaseAmount;
-- END

--Else	SET    @NewBalance =  @LastBalance ;

--Select  '000' as AuthCode, @ReplyCode  as ReplyCode ,  @NewBalance  as NewBalance;
