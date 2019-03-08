
CREATE PROCEDURE [dbo].[p_import_prepaid_update_balance]

 AS

declare @startTime varchar(25) , @DestANI char(10), @charge numeric(7,2)
--select [Start Time],[Dest ANI] from prepaidbilledtemp

DECLARE Record_Cursor CURSOR FOR  Select [Start Time],[Dest ANI],[Est Charges] from prepaidbilledtemp with(nolock)  


OPEN   Record_Cursor

FETCH NEXT FROM   Record_Cursor Into  @startTime, @DestANI, @charge
WHILE @@FETCH_STATUS = 0
  BEGIN
	If (select  count(*) from prepaidbilled with(nolock) where [Start Time] = @startTime and [Dest ANI] =@DestANI) = 0
	  Begin
		 Update tblprepaid Set balance = balance - @charge where PhoneNo  =@DestANI
		 insert prepaidbilled select * from prepaidbilledtemp where [Start Time] = @startTime and [Dest ANI] =@DestANI
	  End
  	FETCH NEXT FROM   Record_Cursor Into  @startTime, @DestANI, @charge
  End
close Record_Cursor
Deallocate Record_Cursor

