-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_user]
@userID varchar(20)
AS
BEGIN
	
Open Symmetric key ICONAccessSymmetrickey
Decryption by Asymmetric key ICONAccessAsymmetricKey

select userID,password,facilityId,  Convert(varchar(18),DECRYPTBYKEY(PasswordDEC)) 
  from tblUserprofiles   where  UserID =@userID

close Symmetric key ICONAccessSymmetrickey
END

