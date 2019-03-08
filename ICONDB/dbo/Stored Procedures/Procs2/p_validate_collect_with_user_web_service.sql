CREATE PROCEDURE [dbo].[p_validate_collect_with_user_web_service]
@username	varchar(25),
@password	varchar(25),
@tono		varchar(10),
@billtype	varchar(2),
@creditcardNo	varchar(19),
@IPaddress	varchar(18),
@ResponseCode varchar(3) OUTPUT,
@cardType	varchar(1) OUTPUT
AS
declare @FacilityID int ;
SET @ResponseCode ='999';
SET   @FacilityID =1;
SET @cardType ='';
if(@billtype ='01' or @billtype ='02' or @billtype ='00')
 begin
	exec  p_preValidate_check2  @FacilityID	,@ToNo , @ResponseCode   Output ;
	
 end 
else
 begin
	if(len(@creditcardNo)<13)
		SET  @ResponseCode ='400';
	else 
		exec sp_validate_creditCard  @creditcardNo , @cardType	OUTPUT, @tono ;
 end

SET @ResponseCode = ltrim(rtrim(@ResponseCode));
if (@ResponseCode = '' or @ResponseCode is null )
	set @ResponseCode ='999';
