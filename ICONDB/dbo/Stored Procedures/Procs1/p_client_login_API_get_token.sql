CREATE PROCEDURE [dbo].[p_client_login_API_get_token]
@userID	varchar(25),
@password	varchar(25)
 AS

SET nocount on;
Declare @Token varchar(25),@FacilityID int;
SET @FacilityID =0;

SELECT @FacilityID = siteID from tblclientusers  with(nolock) where   username= @userID and password = @password ;
if(@FacilityID>0)
 begin
	SET @Token  = NEWID() ;
	Update tblAPIToken  set Tkstatus =0 Where FacilityID =@FacilityID;
	Insert tblAPIToken (facilityID, Token, createdDate, userID) values(@FacilityID,@Token,getdate(),@userID);
	SELECT @Token as Token ;
 end
else
	select '0' as Token


