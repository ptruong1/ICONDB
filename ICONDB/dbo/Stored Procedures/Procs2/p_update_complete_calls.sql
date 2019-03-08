
CREATE PROCEDURE [dbo].[p_update_complete_calls]
@projectcode	char(6),
@calldate	char(6),
@duration	int,
@billtype	char(2),
@totalCharge	numeric(5,2),
@minDuration	int,
@NextMinute	numeric(5,2),
@MinIncrement	tinyint, 
@AcctNo		varchar(12),
@RecFileName	varchar(20)
 AS

SET NOCOUNT ON
Declare  @callCharge  numeric(5,2) ,@billabletime int

Update  tblLivemonitor   SET  status = 'C',   duration =  @duration , LastUpdate = getdate()    where   projectcode = @projectcode and calldate = @calldate

If(@billtype = '07'  ) 
 Begin
	 If( @duration <60)
		SET  @duration = 0
	else
		 SET  @duration = @duration -30
 End

If(@duration >10)
 Begin
	declare @i1  int , @i2 int 
	SET   @i1 =0
	SET   @i2 =0
	EXEC @i1 =  p_update_current_calls @duration , @RecFileName  ,  @projectcode , @calldate 
	If   (@i1 =0)  
	  Begin
		EXEC @i2 =  p_insert_billed_calls @projectCode ,@calldate, 	@billtype 
	  End
 	SET @billabletime = dbo.fn_calculateBillableTime (@duration, @minDuration ,@MinIncrement)  
	SET  @callCharge = @totalCharge + ( (@billabletime - @minDuration) * @NextMinute)
	If (  @i1 =0 and   @i2 =0 )
	 Begin
		If(@billtype = '07')  -- Update balance
		  Begin
			
			Update tbldebit SET balance = balance - @callCharge, modifydate = getdate(),status=1 where AccountNo = @AcctNo	
			Update tbldebit SET balance = 0 , modifydate = getdate() where AccountNo = @AcctNo and balance <0
		  end
		
		
		Else If(@billtype = '10')  -- Update balance
		  Begin
			
			Update tblPrepaid SET balance = balance - @callCharge, modifydate = getdate() , UserName ='Enduser',status=1 where PhoneNo = @AcctNo	
			Update tblPrepaid SET balance =0 , modifydate = getdate() , UserName ='Enduser' where PhoneNo = @AcctNo and  balance <0
		  end
	
	 End
End 

return 0

