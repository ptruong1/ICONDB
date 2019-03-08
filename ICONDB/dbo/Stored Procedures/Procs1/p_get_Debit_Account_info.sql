
CREATE PROCEDURE [dbo].[p_get_Debit_Account_info]
@InmateID		varchar(12),
@facilityID	int,
@AccountNo	varchar(12)  OUTPUT,
@balance	smallmoney  OUTPUT

 AS
SET NOCOUNT ON; 
SET  @AccountNo	 ='';
SET  @balance = 0;

SELECT @AccountNo =  AccountNo, @balance =isnull( balance,0) From tblDebit  where InmateID= @inmateID	AND facilityID = @facilityID  and status =1;

Return @@Error;

