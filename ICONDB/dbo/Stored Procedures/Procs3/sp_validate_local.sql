
CREATE PROCEDURE [dbo].[sp_validate_local]
@billToNo  char(10) 
 AS
Declare  @billable  char, @lastAccess datetime,  @datediff   smallint, @dailyAccess smallint, @fraudAccount smallint
SET  @billable  = 'Y'

SET @fraudAccount  = 0;

--EXEC @fraudAccount =  sp_fraud_account  @billToNo 


return @fraudAccount;

