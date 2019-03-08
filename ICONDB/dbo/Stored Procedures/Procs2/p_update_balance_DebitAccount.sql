
CREATE PROCEDURE [dbo].[p_update_balance_DebitAccount]
@AccountNo	varchar(12),
@timeUsed	int
AS
declare @callCharge numeric(7,2)

SET  @callCharge = CEILING(CAST(@timeUsed as numeric(8,2)) / 60) *  0.5
Update tbldebit SET balance = balance - @callCharge, modifydate = getdate() , UserName='Released'  where AccountNo = @AccountNo	
Update tbldebit SET balance = 0 , modifydate = getdate(),  UserName='Released'  where AccountNo = @AccountNo	 and balance <0

