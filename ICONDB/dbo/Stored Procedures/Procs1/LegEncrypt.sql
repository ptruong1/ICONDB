-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LegEncrypt]
	@Data varchar(30),
	@EnCryptData varbinary(1000) OUTPUT
AS
BEGIN

	SET NOCOUNT ON;

    Open Symmetric key ICONAccessSymmetric
	Decryption by Asymmetric key ICONAccessAsymmetric
	SET @EnCryptData=  EncryptbyKey(Key_GuID('ICONAccessSymmetric'),@Data)
	close Symmetric key ICONAccessSymmetric
END

