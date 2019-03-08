-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_monthly_fee_process] 
@feeID	tinyint	
AS
BEGIN
	Declare @facilityID int, @AccountNo varchar(15), @Balance  numeric(7,2) , @FeeAmount numeric(6,2) ,  @purchaseID bigint
	DECLARE Acount_records  CURSOR FOR  
	 SELECT   C.facilityID, P.phoneno, P.balance, FeeAmount from tblFees F, tblfacility  C, tblprepaid P
				 where F.facilityID = C.facilityID and P.facilityID = C.facilityID and
				  FeeDetailID=@feeID  and P.facilityID =479 and P.status=1 and P.balance > 0

	OPEN  Acount_records
	FETCH NEXT FROM  Acount_records   INTO  @facilityID , @AccountNo, @Balance , @FeeAmount


	WHILE @@FETCH_STATUS = 0		
	  BEGIN
	  Declare @return_value int, @nextID bigint, @ID bigint, @tblpurchase nvarchar(32), @tblDebitPayments nvarchar(32) ;
	  EXEC   @return_value = p_create_nextID 'tblpurchase', @nextID   OUTPUT
       set           @ID = @nextID ;
	           Insert tblpurchase(PurchaseNo, AccountNo  , PurchaseDate,  ProcessedBy  ) values (@ID, @AccountNo , getdate(), 'MRC')
		SET @purchaseID =SCOPE_IDENTITY()
		
		INSERT  tblpurchasedetail( PurchaseNo,  DetailCat, Detailtype, Amount  )  values( @purchaseID, 1, @feeID, @FeeAmount)

		
		UPDATE tblPrepaid  Set Balance = Balance - @FeeAmount,  ModifyDate = getdate()   where PhoneNo =@AccountNo
	 

	     FETCH NEXT FROM  Acount_records   INTO  @facilityID , @AccountNo, @Balance , @FeeAmount
	  End
	close Acount_records
	deallocate Acount_records
END

