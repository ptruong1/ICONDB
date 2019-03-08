CREATE PROCEDURE [dbo].[p_client_login_API]
@userID	varchar(25),
@password	varchar(25)
 AS

SET nocount on;
Declare @Token varchar(25),@FacilityID int;
SET @FacilityID =0;

SELECT @FacilityID = siteID from tblclientusers  with(nolock) where   username= @userID and password = @password ;
if(@FacilityID>0)
	SELECT NEWID() as Token
else
	select '0' as Token
