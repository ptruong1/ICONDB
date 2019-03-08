
CREATE PROCEDURE [dbo].[P_INSERT_Update_TaxRefund_02092017]
( @RefundID int
           , @BillToNo varchar(12)
           , @BillType varchar(2)
           , @RefundAmount numeric(6,2)
           , @FedTaxRef numeric(4,2)
           , @StateTaxRef numeric(4,2)
           , @LocalTaxRef numeric(4,2)
           , @RefundDate datetime
           , @UserName varchar(25)
		   , @State varchar(2)
		   ,@StateAccountNameID tinyint
			,@LocalAccountNameID tinyint
			,@TaxCategoryID tinyint
			,@CallType varchar(2)
			)
AS
	SET NOCOUNT OFF;
	
	if (select count(*) from [dbo].[tblTaxesRefund] where RefundID = @RefundID) > 0
	Begin
		UPDATE [dbo].[tblTaxesRefund]
	   SET 
			  BilltoNo =  @BillToNo 
			, BillType = @BillType
           , RefundAmount = @RefundAmount 
           , FedTaxRef = @FedTaxRef 
           , StateTaxRef = @StateTaxRef 
           , LocalTaxRef = @LocalTaxRef 
           , RefundDate = @RefundDate 
           , UserName = @UserName
		   , [State] = @State
		   , [CallType] = @CallType
		 
		WHERE RefundID = @RefundID
		end
	else
	Begin
	Declare  @return_value int, @nextID int, @ID int, @tblTaxesRefund nvarchar(32) ;
	 EXEC   @return_value = p_create_nextID 'tblTaxesRefund', @nextID   OUTPUT
        set           @ID = @nextID ; 

	INSERT INTO [dbo].[tblTaxesRefund]
			   ([RefundID]
			   ,BilltoNo 
			, BillType
           , RefundAmount 
           , FedTaxRef
           , StateTaxRef
           , LocalTaxRef 
           , RefundDate 
           , UserName  
		   , [State]
		   , StateAccountNameID
			, LocalAccountNameID
			,TaxCategoryID
			,CallType)
		 VALUES
			   (@ID
			   , @BillToNo
           , @BillType 
           , @RefundAmount
           , @FedTaxRef
           , @StateTaxRef 
           , @LocalTaxRef 
           , @RefundDate 
           , @UserName  
		   , @State 
		   ,  @StateAccountNameID 
			, @LocalAccountNameID
			,@TaxCategoryID
			,@CallType)

	End ;
SELECT        RefundID
			   ,BilltoNo 
			, BillType
           , RefundAmount 
           , FedTaxRef
           , StateTaxRef
           , LocalTaxRef 
           , RefundDate 
           , UserName  
		   , [State]
		   , StateAccountNameID
			, LocalAccountNameID
			, TaxCategoryID
			,CallType

  FROM [leg_Icon].[dbo].[tblTaxesRefund]

  
