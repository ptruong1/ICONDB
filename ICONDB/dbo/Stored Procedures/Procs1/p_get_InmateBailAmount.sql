
CREATE PROCEDURE [dbo].[p_get_InmateBailAmount]
@PIN  varchar(12),
@facilityID	int ,
@BailAmount	Numeric(8,2)  OUTPUT

 AS
SET @BailAmount	 =0

	select   @BailAmount	=  sum(BAILAMOUNT)	   From  tblInmateBookInfo   where   PIN =  @PIN

