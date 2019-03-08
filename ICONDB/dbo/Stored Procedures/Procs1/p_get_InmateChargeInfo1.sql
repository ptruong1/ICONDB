
CREATE PROCEDURE [dbo].[p_get_InmateChargeInfo1]
@PIN  varchar(12),
@facilityID	int 


 AS


	select   ChargeCode , Level,  ChargeDescript     From  tblInmateBookInfo   where   PIN =  @PIN  and  len(ChargeCode ) >4 ;

