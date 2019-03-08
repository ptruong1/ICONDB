
CREATE PROCEDURE [dbo].[p_get_InmateBailAmount1]
@PIN  varchar(12),
@facilityID	int ,
@BailAmount	Numeric(8,2)  OUTPUT

 AS
SET @BailAmount	 =0
	select   ChargeCode , Level, BAILAMOUNT     From  tblInmateBookInfo   where   PIN =  @PIN  and BailOUT ='Y'  and  len(ChargeCode ) >4;
	select   @BailAmount	=  sum(BAILAMOUNT)	   From  tblInmateBookInfo   where   PIN =  @PIN and BailOUT ='Y';

