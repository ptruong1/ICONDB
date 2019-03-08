
CREATE PROCEDURE [dbo].[p_SELECT_Prepaid_Accounts]
@PhoneNo varchar(10)
AS
SELECT [PhoneNo]
      
      ,[FirstName]
      ,[LastName]
      ,[MI]
      ,[Address]
      ,[City]
      ,[State]
      ,[ZipCode]
      ,[Country]
      ,[Balance]
      ,[StateID]
	  ,Cast((select Rate from tbltaxes where TaxTypeID = 1) as decimal(2,2))  FedTaxRate
	  ,Cast((select Rate from tbltaxes where state = P.State and TaxTypeID = 2) as decimal(2,2)) as StateTaxRate
	  ,(select Rate from tbltaxes where state = P.State and TaxTypeID = 3) as CountyTaxRate
	  ,(select Rate from tbltaxes where state = P.State and TaxTypeID = 4) as CityTaxRate
	  ,(select Rate from tbltaxes where state = P.State and TaxTypeID = 5) as LocalTaxRate
  FROM [leg_Icon].[dbo].[tblPrepaid] P
  where PhoneNo = @PhoneNo



