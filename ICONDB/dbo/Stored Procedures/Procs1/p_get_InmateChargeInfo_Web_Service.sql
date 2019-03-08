
CREATE PROCEDURE [dbo].[p_get_InmateChargeInfo_Web_Service]
@PIN  varchar(12),
@facilityID	int

 AS
 Declare   @ChargeCode 	varchar(30) ,@ChargeDescript  varchar(60) ;
SET  @ChargeCode ='';

	select   @ChargeCode 	= ChargeCode ,   @ChargeDescript = ChargeDescript     From  tblInmateBookInfo   where   PIN =  @PIN and  len(ChargeCode ) >4;
	
	SELECT  @ChargeCode as ChargeCode ,   @ChargeDescript as ChargeDescript ;

