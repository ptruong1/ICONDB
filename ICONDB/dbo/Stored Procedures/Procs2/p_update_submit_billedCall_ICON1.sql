
CREATE PROCEDURE [dbo].[p_update_submit_billedCall_ICON1]
@recordID	bigint,
@complete  char(1)
 AS
SET NOCOUNT ON;
Declare @ccNo varchar(16) , @calldate char(6), @creditcardType char(1);
SET @creditcardType ='0';

If( @complete = '2' )
 begin
 --	select @ccNo = creditcardNo, @calldate=calldate, @creditcardType =CreditCardType  from tblcallsbilled where recordID = @recordID	  and AgentID not in ( 404,225)	;		
 
	--if(select count(*) from tblcallsbilled  where creditcardNo=@ccNo and  errorCode =0  and (billType  =  '03'  or   billType  =  '05' )    and    complete =2  and calldate = @calldate  ) >3
	--	Update  tblcallsbilled  SET  errorcode='4' ,creditcardNo = left(creditcardNo,4) + '***' + RIGHT(creditcardNo,4)  where RecordID =@recordID 
	--else			
		Update  tblcallsbilled  SET Complete=@complete , errorcode='0' , creditcardNo = left(creditcardNo,4) + '***' + RIGHT(creditcardNo,4)   where RecordID =@recordID;
		Update tblTaxesBilled set Billedstatus =1 where referenceNo = @recordID;
		
 end      
Else
	Update  tblcallsbilled  SET Complete=@complete, Errorcode='3',creditcardNo = left(creditcardNo,4) + '***' + RIGHT(creditcardNo,4)   where RecordID =@recordID;


