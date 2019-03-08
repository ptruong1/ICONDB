
CREATE PROCEDURE [dbo].[p_Insert_UPDATE_TaxJurisName]
(
	@TaxingJurisNameID int,
	@Name varchar(50),
	@TaxType tinyint	
)
AS
	SET NOCOUNT OFF;
	
	If (select count(*) from tblTaxingJurisName WHERE TaxingJurisNameID = @TaxingJurisNameID ) > 0
	Begin
		UPDATE [tblTaxingJurisName] 
		SET  [Name] = @Name 
		
		WHERE ([TaxingJurisNameID] = @TaxingJurisNameID)
	End
	else
	Begin
	Declare  @return_value int, @nextID int, @ID int, @tblTaxingJurisName nvarchar(32) ;
	 EXEC   @return_value = p_create_nextID 'tblTaxingJurisName', @nextID   OUTPUT
        set           @ID = @nextID ; 
		INSERT INTO [dbo].[tblTaxingJurisName]
			   ([TaxingJurisNameID]
			   ,[Name]
			   ,TaxType)
		 VALUES
			   (@ID
			   ,@Name
			   ,@TaxType)
	End

SELECT TaxingJurisNameID, Name, TaxType FROM tblTaxingJurisName WHERE (TaxingJurisNameID = @TaxingJurisNameID)

