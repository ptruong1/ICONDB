
CREATE PROCEDURE [dbo].[p_Insert_UPDATE_TaxType]
(
	@TaxTypeID int,
	@TaxTypeName varchar(32)
		
)
AS
	SET NOCOUNT OFF;
	
	If (select count(*) from tblTaxTypes WHERE TaxTypeID = @TaxTypeID ) > 0
	Begin
		UPDATE [tblTaxTypes] SET  [TaxTypeName] = @TaxTypeName WHERE ([TaxTypeID] = @TaxTypeID)
	End
	else
	Begin
	Declare  @return_value int, @nextID int, @ID int, @tblTaxTypes nvarchar(32) ;
	 EXEC   @return_value = p_create_nextID 'tblTaxTypes', @nextID   OUTPUT
        set           @ID = @nextID ; 
		INSERT INTO [dbo].[tblTaxTypes]
			   ([TaxTypeID]
			   ,[TaxTypeName])
		 VALUES
			   (@ID
			   ,@TaxTypeName)
	End

SELECT TaxTypeID, TaxTypeName FROM tblTaxTypes WHERE (TaxTypeID = @TaxTypeID)

