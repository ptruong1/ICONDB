
CREATE PROCEDURE [dbo].[p_SELECT_Tax_Refund_ByRefundID]

(@RefundID int,
 @State varchar(2))  
            
AS
declare @FedTaxRate decimal(2,2),
@StateTaxRate decimal(2,2),
@LocalTaxRate decimal(2,2)
set @FedTaxRate = 0.00
set @StateTaxRate = 0.00
set @LocalTaxRate = 0.00

		--Cast((select isnull(Rate,0) from tbltaxes where TaxTypeID = 1) as decimal(2,2))  FedTaxRate
	 -- ,Cast((select isnull(Rate,0) from tbltaxes where state = @State and TaxTypeID = 2) as decimal(2,2)) as StateTaxRate
	 --(select @FedTaxRate = Rate from tbltaxes where TaxTypeID = 1) 
	 --(select @StateTaxRate = Rate from tbltaxes where state = @State and TaxTypeID = 2 and TaxID = )
 	-- (select @LocalTaxRate= Rate from tbltaxes where state = @State and TaxTypeID = 5 )

SELECT [RefundID]
      ,[BillToNo]
      ,[BillType]
      ,[RefundAmount]
      ,[FedTaxRef]
      ,[StateTaxRef]
      ,[LocalTaxRef]
      ,[RefundDate]
      ,[UserName]
	  ,[State]
	  ,StateAccountNameID
	  ,LocalAccountNameID
	  ,(Select TaxingJurisName from [leg_Icon].[dbo].[tblTaxes] T where R.StateAccountNameID = T.taxID) as StateAccountName
	  ,(Select TaxingJurisName from [leg_Icon].[dbo].[tblTaxes] T where R.LocalAccountNameID = T.taxID) as LocalAccountName
	  ,(select Rate from tbltaxes T where TaxTypeID = 1 and R.TaxCategoryID = T.TaxCategoryID) as FedTaxRate
	  ,(Select Rate from [leg_Icon].[dbo].[tblTaxes] T where R.StateAccountNameID = T.taxID and R.TaxCategoryID = T.TaxCategoryID) as StateTaxRate
	  ,(Select Rate from [leg_Icon].[dbo].[tblTaxes] T where R.LocalAccountNameID = T.taxID and R.TaxCategoryID = T.TaxCategoryID) as LocalTaxRate

	  --,@FedTaxRate as FedTaxRate, @StateTaxRate as StateTaxRate, @LocalTaxRate as LocalTaxRate

  FROM [leg_Icon].[dbo].[tblTaxesRefund] R
  
  where RefundID = @RefundID


