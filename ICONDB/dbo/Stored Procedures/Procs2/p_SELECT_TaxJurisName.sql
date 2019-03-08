
CREATE PROCEDURE [dbo].[p_SELECT_TaxJurisName]

AS
SELECT [TaxingJurisNameID], [Name], [TaxType], B.TaxTypeName as TaxTypeName FROM [tblTaxingJurisName] A
                        left join tblTaxTypes B on A.TaxType = B.TaxTypeID

ORDER BY TaxType, TaxingJurisNameID

