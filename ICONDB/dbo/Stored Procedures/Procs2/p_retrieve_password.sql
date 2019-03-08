-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_password]
@userID varchar(25)
AS
BEGIN
	
Open Symmetric key ICONAccessSymmetrickey
	Decryption by Asymmetric key ICONAccessAsymmetricKey;
	select Convert(varchar(30),DECRYPTBYKEY(PasswordDEC)), Email   from tblUserprofiles where UserID=@userID;
close Symmetric key ICONAccessSymmetrickey;
END

