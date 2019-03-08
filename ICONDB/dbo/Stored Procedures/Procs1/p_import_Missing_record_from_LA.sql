CREATE PROCEDURE p_import_Missing_record_from_LA

 AS

declare @RecordID  bigint ,@Calldate  char(6),@tono  char(10),@Callrevenue numeric(7,2)  , @billtype char(2) ,@AccountNo varchar(16)
--select [Start Time],[Dest ANI] from prepaidbilledtemp

DECLARE Record_Cursor CURSOR FOR  select   RecordID,Calldate,tono,Callrevenue,billtype,creditcardno   from tblcallsbilledtemp      order by RecordID 


OPEN   Record_Cursor

FETCH NEXT FROM   Record_Cursor Into @RecordID,@Calldate,@tono,@Callrevenue, @billtype,@AccountNo
WHILE @@FETCH_STATUS = 0
  BEGIN
	If (select  count(*) from tblCallsbilled with(nolock) where  recordID = @recordID and calldate = @Calldate) = 0 
	  Begin	
		insert  tblcallsbilled  select * from  tblcallsbilledtemp  where   recordID = @recordID and calldate = @Calldate
		if (@billtype = '10')
			update tblprepaid set balance =  balance - @Callrevenue where phoneno = @tono
		if (@billtype = '07')  
			update tbldebit set balance =  balance - @Callrevenue where AccountNo =@AccountNo
	  End
  	FETCH NEXT FROM   Record_Cursor Into @RecordID,@Calldate,@tono,@Callrevenue, @billtype,@AccountNo
  End
close Record_Cursor
Deallocate Record_Cursor