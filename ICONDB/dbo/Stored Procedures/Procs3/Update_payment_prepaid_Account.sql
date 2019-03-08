

CREATE PROCEDURE [dbo].[Update_payment_prepaid_Account]
@AccountNo  varchar(10),
@facilityID int,
@CallAmount    numeric(7,2) ,  
@setupFee	numeric(7,2) ,  
@ProcessFee	    numeric(7,2) ,  
@tax		      numeric(7,2) ,  
@paymentTypeID  int , 
@checkNo	VARCHAR(10), 
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccCVV	VARCHAR(4)	,
@BilltoFirstName	VARCHAR(20)	, 
@BillToLastName	VARCHAR(20),  
@BillToEmail	varchar(30),
@BillToAddress	varchar(50),
@BillToCity	varchar(30),
@BillToZip		VARCHAR(5), 
@BillToState	varchar(2),
@BillToCountry	varchar(30),
@UserName	VARCHAR(20)


AS
SET NoCount ON
declare  @purchaseID bigint, @authAmount	numeric(7,2)
Declare @return_value int, @nextID bigint, @ID bigint, @tblTransactionLogs nvarchar(32), @tblpurchase nvarchar(32), @tblPrepaidPayments nvarchar(32) ;
SET  @authAmount = @callAmount + @ProcessFee + @tax + @setupFee
 
 Begin
		EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;  
		Insert tblpurchase(PurchaseNo, AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), @UserName)
		SET @purchaseID =@ID
		If(@setupFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @setupFee)
		If (@Tax >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 4, @Tax)
		
		If (@ProcessFee >0) 
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee)
	
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @CallAmount)
		
		EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
        set           @ID = @nextID ;
		INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate  )
					        Values(@ID, @AccountNo, @FacilityID, @authAmount , @PaymentTypeID, @checkno, @ccNo, @ccExp,@BilltoZip, @ccCVV, @BillToFirstName,@BillToLastName	,@userName, getdate())
		UPDATE tblPrepaid  Set Balance = Balance + @CallAmount, paymentTypeID= @paymentTypeID, ModifyDate = getdate()  where PhoneNo =@AccountNo
	

 End

