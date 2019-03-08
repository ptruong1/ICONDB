CREATE PROCEDURE [dbo].[p_verify_Debit_account_from_outside]
@accountNo	varchar(12),
@facilityID	int  OUTPUT,
@balance  	numeric(6,2)  OUTPUT
AS
SET @facilityID =1

If(Select count(accountNo )  from tblDebit  with(nolock) where accountNo = @accountNo) > 0
 Begin
	select @facilityID =  facilityID, @balance = balance   from tblDebit  with(nolock) where accountNo = @accountNo
	If(@balance <0)  SET  @balance =0
 end
Else
	Return -1
