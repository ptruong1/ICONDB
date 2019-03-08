
CREATE PROCEDURE [dbo].[p_Insert_UPDATE_TaxCategory]
(
	@TaxCategoryID int,
	@Name varchar(32)
		
)
AS
	SET NOCOUNT OFF;
	
	If (select count(*) from tblTaxCategory WHERE TaxCategoryID = @TaxCategoryID ) > 0
	Begin
		UPDATE [tblTaxCategory] SET  [Name] = @Name WHERE ([TaxCategoryID] = @TaxCategoryID)
	End
	else
	Begin
	Declare  @return_value int, @nextID int, @ID int, @tblTaxCategory nvarchar(32) ;
	 EXEC   @return_value = p_create_nextID 'tblTaxCategory', @nextID   OUTPUT
        set           @ID = @nextID ; 
		INSERT INTO [dbo].[tblTaxCategory]
			   ([TaxCategoryID]
			   ,[Name])
		 VALUES
			   (@ID
			   ,@Name)
	End

SELECT TaxCategoryID, Name FROM tblTaxCategory WHERE (TaxCategoryID = @TaxCategoryID)

