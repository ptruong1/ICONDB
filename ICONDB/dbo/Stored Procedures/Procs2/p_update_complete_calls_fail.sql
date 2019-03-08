
CREATE PROCEDURE [dbo].[p_update_complete_calls_fail]
@projectcode	char(6),
@calldate	char(6),
@duration	int,
@billtype	char(2)

 AS

Declare  @callCharge  numeric(5,2) ,@billabletime int ,@totalCharge	numeric(5,2), @minDuration	int, @NextMinute	numeric(5,2), @MinIncrement	tinyint,  @AcctNo varchar(10) 

Update  tblLivemonitor   SET  status = 'C',   duration =  @duration , LastUpdate = getdate()    where   projectcode = @projectcode and calldate = @calldate

If(select count(*) from tblcalls with(nolock) where  calldate = @calldate and projectcode = @projectcode and duration is null  and Errorcode ='0')  >0    and @duration >10

Begin
	
	If(@billtype = '07'  ) 
	 Begin
		 If( @duration <60)
			SET  @duration = 0
		else
			 SET  @duration = @duration -30
	 End	
	If( @duration > 10)
	 Begin
		Update  tblcalls  SET duration =  @duration , Dberror ='Y'  where  calldate = @calldate and projectcode = @projectcode  
		EXEC p_insert_billed_calls @projectCode ,@calldate, 	@billtype 
		
		select  @callCharge=isnull(  CallRevenue,0)  from  tblcallsbilled  with(nolock)  where  calldate = @calldate and projectcode = @projectcode  
		
		If(@billtype = '07')  -- Update balance
		  Begin
			Select @AcctNo = Billtono , @minDuration = Minduration ,  @MinIncrement = MinIncrement ,  @totalCharge = ConnectFee + FirstMinute  from tblcalls with(nolock)  where calldate = @calldate and projectcode = @projectcode
			Update tbldebit SET balance = balance - @callCharge,status=1 where AccountNo = @AcctNo	
		  end
		
		
		Else If(@billtype = '10')  -- Update balance
		  Begin
			Select @AcctNo = Billtono , @minDuration = Minduration ,  @MinIncrement = MinIncrement ,  @totalCharge = ConnectFee + FirstMinute  from tblcalls with(nolock)  where  calldate = @calldate and projectcode = @projectcode
			
			Update tblPrepaid SET balance = balance - @callCharge,status=1 where PhoneNo = @AcctNo	
		  end
	 End
end 

  return 0

