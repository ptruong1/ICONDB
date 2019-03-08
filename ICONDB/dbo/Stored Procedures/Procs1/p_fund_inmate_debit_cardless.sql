/****** Object:  StoredProcedure [dbo].[p_process_inmate_debit_cardless]    Script Date: 11/14/2013 15:55:37 ******/

CREATE PROCEDURE [dbo].[p_fund_inmate_debit_cardless]
@facilityID	int,
@InmateID	varchar(12),
@PurchaseAmount		numeric(5,2), -- true amount fund to Account
@ProcessFee numeric(5,2),
@userName varchar(20),
@PaymentTypeID	tinyint,
@Balance   numeric(7,2) OUTPUT

AS
SET NOCOUNT ON;
Declare @AccountNo  varchar(12), @lastBalance numeric(7,2),@purchaseID bigint, @authAmount numeric(7,2);

SET @AccountNo ='0';
SET @paymentTypeID = isnull(@paymentTypeID,1);
EXEC  [leg_Icon].[dbo].[p_create_debit_account_with_inmate]
			@facilityID	,
			@InmateID	,
			'','',
			@PurchaseAmount	,
			'Process Enduser',
			@AccountNo OUTPUT ;
			
SELECT  @Balance =  balance From tblDebit where  AccountNo =  @AccountNo ;			
 
--INSERT tblpurchase(  AccountNo  , PurchaseDate,  ProcessedBy  ) values (@AccountNo , getdate(), @UserName);

--INSERT tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, 3, @ProcessFee);
	
--INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 2, 2, @PurchaseAmount);


--SET @LastBalance = ISNULL(@LastBalance,0);

--SET @Balance = @LastBalance + @PurchaseAmount;

--INSERT INTO tblDebitPayments(AccountNo, FacilityID,  InmateID, Amount   ,    PaymentTypeID, CheckNo  ,  CCNo  , CCExp ,CCzip ,CCcode, CCFirstName,CCLastName ,  UserName ,  PaymentDate, PurchaseNo,LastBalance  )
			        --Values(@AccountNo, @FacilityID, @inmateID, @authAmount , @PaymentTypeID, '','', '','', '', '',''	,@userName, getdate(), @purchaseID, @LastBalance);


	
