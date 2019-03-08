
CREATE PROCEDURE [dbo].[p_prepaid_payment]
@AccountNo  varchar(12),
@PurchaseAmount    numeric(7,2) ,  
@Fee	numeric(7,2) ,  
@Tax	numeric(7,2) , 
@ccNo		VARCHAR(16), 
@ccExp	VARCHAR(4),
@ccZip		varchar(5),
@ccCVV	VARCHAR(4),
@paymentTypeID tinyint,
@TerminalID  varchar(15),
@UserName  varchar(20)
AS
SET NoCount ON;
declare  @purchaseID bigint, @authAmount	numeric(7,2),   @LastBalance  numeric(7,2) , @EnduserID int, @facilityID int,@NewBalance	numeric(7,2);
Declare @return_value int, @nextID bigint, @ID bigint,  @tblTransactionLogs nvarchar(32), @tblpurchase nvarchar(32), @tblPrepaidPayments nvarchar(32) ;

SET  @authAmount = @PurchaseAmount + @Fee+ @Tax;
SET  @LastBalance  = 0;
if(len(@AccountNo) =11 and left(@AccountNo,1) in ('1','0'))   -- Edit on 12/2/2016 to detect 1 or 0 infront 
 Begin
	SET @AccountNo = right(@AccountNo,10) ;
 End



 SELECT  @LastBalance =  balance  , @EndUserID = EnduserID,@facilityID =FacilityID   From tblprepaid  with(nolock)  where  phoneNo =  @AccountNo ;

 if(@EnduserID is null or @EnduserID =0 or @facilityID =0)
  begin
	EXEC p_register_new_prepaid_Account3 
									1,	
									@AccountNo,
									'New Account',
									'',
									'', 
									'',
									1,
									'USA',
									'New Account',
									'For Prepaid',
									'no@email.com',
									@AccountNo,
									'Auto',
									'NA',
									99,
									0,
									'' ;

  end

	EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
    SET @purchaseID = @nextID ; 
	Insert tblpurchase(PurchaseNo,  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@purchaseID, @AccountNo , getdate(), @TerminalID);
	
	If (select count (*) from tblpurchase with(nolock) where AccountNo = @AccountNo ) =0
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 1, @Fee);
	else
		insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @Fee);

	INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);

	If (@Tax >0) 
	 begin
			insert tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values(@purchaseID, 1, 4, @Tax);
	 end

	  EXEC   @return_value = p_create_nextID 'tblPrepaidPayments', @nextID   OUTPUT
      SET        @ID = @nextID ;  
	INSERT INTO tblPrepaidPayments(paymentID, AccountNo, FacilityID,  Amount   ,    PaymentTypeID,  CCNo  , CCExp ,CCzip ,CCcode,  PaymentDate, PurchaseNo,LastBalance, UserName  )
				        Values(@ID, @AccountNo, @FacilityID, @authAmount , @paymentTypeID,left( @ccNo,4) + "***" + right( @ccNo,4) , @ccExp,@ccZip, @ccCVV, getdate(), @purchaseID, @LastBalance, @UserName);
	
	Update  tblprepaid set Balance = Balance + @PurchaseAmount, [status] =1 , ModifyDate=getdate()  where  phoneNo =  @AccountNo ;

	SET    @NewBalance =  @LastBalance + @PurchaseAmount ;

	Select @AccountNo as AccountNo, @LastBalance as lastBalance,  @NewBalance as Balance , 1 as Success, '010' as ResponseCode,  @purchaseID as ConfirmID;


