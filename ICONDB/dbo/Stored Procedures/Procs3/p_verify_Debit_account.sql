
CREATE PROCEDURE [dbo].[p_verify_Debit_account]
@accountNo	varchar(12),
@inmateID	int  OUTPUT,
@balance  	numeric(6,2)  OUTPUT
AS
SET @inmateID =0

If(Select count(accountNo )  from tblDebit  with(nolock) where accountNo = @accountNo) > 0
 Begin
	select @inmateID =  inmateID, @balance = balance   from tblDebit  with(nolock) where accountNo = @accountNo
	If(@balance <0)  SET  @balance =0
 end
Else
	Return -1

