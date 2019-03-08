-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_retrieve_password_100814]
@userID varchar(25),
@Password varchar(20) OutPut
AS
BEGIN
	
Open Symmetric key ICONAccessSymmetric
	Decryption by Asymmetric key ICONAccessAsymmetric;
	select @Password= Convert(varchar(30),DECRYPTBYKEY(PasswordDEC)) from tblUserprofiles where UserID=@userID;
close Symmetric key ICONAccessSymmetric ;
END

