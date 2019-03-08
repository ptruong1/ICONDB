
CREATE PROCEDURE [dbo].[p_get_DebitAccount_by_PIN]
@PIN		varchar(12),
@facilityID	int,
@AccountNo	varchar(12)  OUTPUT,
@balance	numeric(7,2)  OUTPUT

 AS
Declare @inmateID varchar(12) 
SET  @AccountNo	 ='';
SET  @balance = 0;
Select @inmateID = inmateID from tblInmate where FacilityId = @facilityID and PIN = @PIN;
SELECT @AccountNo =  AccountNo, @balance =isnull( balance,0) From tblDebit with(nolock) where InmateID= @inmateID	AND facilityID = @facilityID  and status =1;

