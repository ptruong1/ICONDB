CREATE PROCEDURE [dbo].[p_validate_call_web_service_v2]
@ANI		varchar(10),
@username	varchar(25),
@password	varchar(25),
@tono		varchar(10),
@billtype	varchar(2),
@creditcardNo	varchar(19),
@IPaddress	varchar(18),
@ResponseCode varchar(3) OUTPUT,
@cardType	varchar(1) OUTPUT,
@MerchantID varchar(15) OUTPUT,
@Allow int  OUTPUT
AS
declare @FacilityID int ;
SET @ResponseCode ='999';
SET   @FacilityID =1;
SET @cardType ='';
SET @MerchantID ='000051325675';
SET @Allow =0;
select @FacilityID = facilityID from tblANIs with(nolock) where  ANINo =  @ANI;

if(@billtype ='01' or @billtype ='02' or @billtype ='00')
 begin
	exec  p_validate_collectCall  @ANI	,@ToNo , @ResponseCode   Output,@FacilityID OUTPUT ;
 end 
else
 begin
	if(len(@creditcardNo)<13  or  len(@creditcardNo) >16) -- for now
		SET  @ResponseCode ='400';
	else 
		exec p_validate_creditCard_v1 @facilityID,  @creditcardNo , @cardType	OUTPUT, @ResponseCode output,@MerchantID OUTPUT ;
 end

SET @ResponseCode = ltrim(rtrim(@ResponseCode));
if (@ResponseCode = '' or @ResponseCode is null )
	set @ResponseCode ='999';

select @FacilityID;
EXEC @Allow= p_determine_billtype_method  @FacilityID,'05' , @tono ; 

if(@Allow =2)  SET  @ResponseCode ='500';

