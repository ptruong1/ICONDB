
CREATE PROCEDURE [dbo].[p_get_prepaid_Script_Service]
@trunkNo	char(4),
@Script             Varchar(100) OUTPUT
 AS

select @Script  =   Script from tblprepaidTrunk with(nolock) where  trunkNo = @trunkNo	

