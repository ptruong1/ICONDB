
CREATE PROCEDURE [dbo].[p_SELECT_TaxType]

AS
SELECT [TaxTypeID]
      ,[TaxTypeName]
  FROM [leg_Icon].[dbo].[tblTaxTypes]
  where TaxTypeID in (1, 2, 5)

ORDER BY TaxTypeID

