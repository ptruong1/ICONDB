CREATE PROCEDURE [dbo].[p_UserAuthority] 
(
	@AuthID int
	
)
AS
	SET NOCOUNT ON;

	BEGIN
		SELECT         admin, monitor, finance, dataEntry, controler
		FROM            tblAuth  with(nolock)  
                         
		WHERE	AuthID = @AuthID
	END
