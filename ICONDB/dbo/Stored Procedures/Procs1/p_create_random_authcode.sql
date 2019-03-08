-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE  [dbo].[p_create_random_authcode]
	@UserName varchar(20),
	@AuthCode as int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @AuthCode = CEILING( RAND ()* 1000000);
	
	Insert tblusersecondfactor  values (@UserName , @AuthCode , getdate());
 End