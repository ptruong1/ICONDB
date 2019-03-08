
CREATE PROCEDURE [dbo].[p_SELECT_Tax_Accounts]

AS
SELECT        [TaxID]
      ,[State]
      ,[TaxingJurisName]
	  ,A.TaxTypeID as TaxTypeID
      ,[TaxTypeName]
      ,[Rate]
      ,[Amount]
      ,[StartDate]
      ,[EndDate]
      ,[LastUpdated]
      ,[TaxOnUsage]
      ,[TaxOnProduct]
      ,A.TaxCategoryID
	  ,C.Name as Category
      ,[TaxOnIntrastate]
      ,[TaxOnInterstate]
      ,[TaxOnInternational]
      ,[UserID]
  FROM [leg_Icon].[dbo].[tblTaxes] A, [leg_Icon].[dbo].[tblTaxTypes] B, [leg_Icon].[dbo].[tblTaxCategory] C
  where A.TaxTypeID = B.TaxTypeID and A.TaxCategoryID = C.TaxCategoryID 

ORDER BY State

