-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_test]
AS
BEGIN
	Create master key encryption by password= 'mylegacy@123!@#'
CREATE Asymmetric key ICONAccessAsymmetricKey
		Authorization ICONAccess 
		With Algorithm =RSA_2048
		

CREATE Symmetric key ICONAccessSymmetrickey		
With Algorithm =RC4
Encryption by Asymmetric key ICONAccessAsymmetricKey


select * from sys.symmetric_keys 
END

