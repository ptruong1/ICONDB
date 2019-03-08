
CREATE PROCEDURE [dbo].[p_SELECT_Tax_Refunds]

AS
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
  FROM [leg_Icon].[dbo].[tblTaxesRefund] R
  

ORDER BY RefundID

