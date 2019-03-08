-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LegDescrypt]
	@EncyptData varbinary(1000),
	@Data varchar(30) OutPut
AS
BEGIN

	SET NOCOUNT ON;

    Open Symmetric key ICONAccessSymmetric
	Decryption by Asymmetric key ICONAccessAsymmetric
	SET @Data= Convert(varchar(30),DECRYPTBYKEY(@EncyptData))
	close Symmetric key ICONAccessSymmetric
END

