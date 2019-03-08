-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_password_031714]
@userID varchar(25)
AS
BEGIN
	
Open Symmetric key ICONAccessSymmetrickey
	Decryption by Asymmetric key ICONAccessAsymmetric
	select Convert(varchar(30),DECRYPTBYKEY(PasswordDEC)) as Password, Email   from tblUserprofiles where UserID=@userID
close Symmetric key ICONAccessSymmetric
END

