
CREATE PROCEDURE [dbo].[p_SELECT_Tax_Accounts_ByTaxID]

(@TaxID int  
            )
AS
SELECT        [TaxID]
      ,[State] as StateCode
      ,[TaxingJurisName]
      ,[TaxTypeID]
      ,[Rate]
      ,[Amount]
      --,isnull(StartDate,'') as StartDate
      --,isnull(EndDate,'') as EndDate
      --,isnull(LastUpdated,'') as LastUpdated
	  ,StartDate
      ,EndDate
      ,LastUpdated
      ,[TaxOnUsage]
      ,[TaxOnProduct]
      ,[TaxCategoryID]
      ,[TaxOnIntrastate]
      ,[TaxOnInterstate]
      ,[TaxOnInternational]
      ,[UserID]
  FROM [leg_Icon].[dbo].[tblTaxes]
  where TaxID = @TaxID


