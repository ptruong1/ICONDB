
CREATE PROCEDURE [dbo].[p_SELECT_Tax_Rate_By_State]
@State varchar(2),
@TaxCategoryID int,
@StateAccountNameID tinyint,
@LocalAccountNameID tinyint

AS
declare @FedTaxRate decimal(2,2),
@StateTaxRate decimal(2,2),
@LocalTaxRate decimal(2,2)

set @FedTaxRate = 0.00
set @StateTaxRate = 0.00
set @LocalTaxRate = 0.00

		--Cast((select isnull(Rate,0) from tbltaxes where TaxTypeID = 1) as decimal(2,2))  FedTaxRate
	 -- ,Cast((select isnull(Rate,0) from tbltaxes where state = @State and TaxTypeID = 2) as decimal(2,2)) as StateTaxRate
	 (select @FedTaxRate = Rate from tbltaxes where TaxTypeID = 1 and TaxCategoryID=@TaxCategoryID) 
	 (select @StateTaxRate = Rate from tbltaxes where state = @State and TaxTypeID = 2 and TaxID = @StateAccountNameID and TaxCategoryID=@TaxCategoryID)
 	 (select @LocalTaxRate= Rate from tbltaxes where state = @State and TaxTypeID = 5 and TaxID = @LocalAccountNameID and TaxCategoryID=@TaxCategoryID)
  
  select @FedTaxRate as FedTaxRate, @StateTaxRate as StateTaxRate, @LocalTaxRate as LocalTaxRate


