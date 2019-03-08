
CREATE PROCEDURE [dbo].[p_verify_Debit_account1]
@accountNo	varchar(12),
@fromNo	char(10),
@PIN		varchar(12),
@facilityID	int,
@userName	varchar(23),
@projectcode	char(6),
@billtype	char(2),
@toNo		varchar(16),
@inmateID	int  OUTPUT,
@balance  	numeric(6,2)  OUTPUT
AS
SET @inmateID =0
SET  @balance =0
If(Select count(accountNo )  from tblDebit  with(nolock) where accountNo = @accountNo    AND Status =1)  > 0 --- AND facilityID = @facilityID
 Begin
	select @inmateID =  inmateID, @balance = balance   from tblDebit  with(nolock) where accountNo = @accountNo
	If(@balance <=0)  
	 Begin
		SET  @balance =0
		EXEC  p_insert_unbilled_calls1   '','',  @fromno ,@toNo,@billtype, 7,@PIN	,0 ,@facilityID	,@userName, '', @projectcode, @accountNo
	 End
 end
Else
 Begin
	EXEC  p_insert_unbilled_calls1   '','',  @fromno ,@toNo,@billtype, 7,@PIN	,0 ,@facilityID	,@userName, '', @projectcode, @accountNo	
	Return -1
  End
