
CREATE PROCEDURE [dbo].[p_get_InmateChargeInfo]
@PIN  varchar(12),
@facilityID	int ,
@ChargeCode 	varchar(30) OUTPUT,
@ChargeDescript  varchar(60)  OUTPUT

 AS
SET  @ChargeCode =''

	select   @ChargeCode 	= ChargeCode ,   @ChargeDescript = ChargeDescript     From  tblInmateBookInfo   where   PIN =  @PIN and  len(ChargeCode ) >4

