
CREATE PROCEDURE [dbo].[p_update_balance_DebitAccount1]
@AccountNo	varchar(12),
 @callCharge  numeric(5,2)
AS

Update tbldebit SET balance = balance - @callCharge, modifydate = getdate() , UserName='Released'  where AccountNo = @AccountNo
