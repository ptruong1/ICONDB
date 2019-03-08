
CREATE PROCEDURE [dbo].[p_UPDATE_TaxCategory]
(
	@TaxCategoryID int,
	@Name varchar(32)
		
)
AS
	SET NOCOUNT OFF;
UPDATE [tblTaxCategory] SET  [Name] = @Name WHERE (([TaxCategoryID] = @TaxCategoryID));
	
SELECT TaxCategoryID, Name FROM tblTaxCategory WHERE (TaxCategoryID = @TaxCategoryID)

