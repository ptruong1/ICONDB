
CREATE PROCEDURE [dbo].[p_SELECT_TaxCategory]

AS
SELECT [TaxCategoryID], [Name] FROM [tblTaxCategory]

ORDER BY TaxCategoryID

