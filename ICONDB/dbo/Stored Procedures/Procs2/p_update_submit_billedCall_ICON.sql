
CREATE PROCEDURE [dbo].[p_update_submit_billedCall_ICON]
@projectcode	varchar(10),
@calldate	char(6),
@complete	char(1)

 AS
if(@complete='2') 
	Update  tblcallsbilled  SET Complete=@complete,  errorcode='0', creditcardNo = left(creditcardNo,4) + '***' + RIGHT(creditcardNo,4)    where projectcode = @projectcode and calldate = @calldate
else
	Update  tblcallsbilled  SET Complete=@complete, errorcode='3' ,  creditcardNo = left(creditcardNo,4) + '***' + RIGHT(creditcardNo,4) where projectcode = @projectcode and calldate = @calldate

