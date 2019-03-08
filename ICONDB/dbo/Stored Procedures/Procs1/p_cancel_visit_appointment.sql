-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_cancel_visit_appointment]
@ApmNo int
AS

BEGIN
	Declare @totalCharge numeric(5,2), @AccountNo varchar(12),@apmtime datetime, @lastBalance numeric(6,2), @currentDate datetime;
	Declare  @return_value int, @nextID int, @ID int, @tblAdjustment nvarchar(32) ;
	SET @totalCharge =0;
	SET @AccountNo ='';
	SET @currentDate = GETDATE();
	select @totalCharge = totalCharge , @AccountNo =EndUserID from [tblVisitEnduserSchedule] 
		 where ApmNo = @ApmNo and (status = 1 or status =2); -- and DATEDIFF(hh,apmtime,getdate()) <=48
	
	if( @AccountNo <>'')
	 begin
		select @lastBalance = balance from leg_Icon.dbo.tblprepaid  where phoneno=@AccountNo;
		Update 	[tblVisitEnduserSchedule]  set [status] =4, CancelBy=@AccountNo where ApmNo = @ApmNo;
		update  leg_Icon.dbo.tblprepaid set Balance=Balance +@totalCharge, ModifyDate =@currentDate
													 where phoneno=@AccountNo;
													 
			EXEC   @return_value = p_create_nextID 'tblAdjustment', @nextID   OUTPUT
             set           @ID = @nextID ;    										 
		insert tblAdjustment (AdjID, AdjTypeID, AccountNo  ,LastBalance ,  AdjAmount  , AdjustDate ,  UserName ,   status)	
						 values(@ID,9,@AccountNo, 	@lastBalance,	-@totalCharge,	@currentDate, 	@AccountNo,1)		;				 
	    return 0;
	 end
	else
		return -1;
END

--BEGIN
--	Declare @totalCharge numeric(5,2), @AccountNo varchar(12),@apmtime datetime, @lastBalance numeric(6,2), @currentDate datetime;
--	SET @totalCharge =0;
--	SET @AccountNo ='';
--	SET @currentDate = GETDATE();
--	select @totalCharge = totalCharge , @AccountNo =EndUserID from [tblVisitEnduserSchedule] 
--		 where ApmNo = @ApmNo and (status = 1 or status =2); -- and DATEDIFF(hh,apmtime,getdate()) <=48
	
--	if( @AccountNo <>'')
--	 begin
--		select @lastBalance = balance from leg_Icon.dbo.tblprepaid  where phoneno=@AccountNo;
--		Update 	[tblVisitEnduserSchedule]  set [status] =4, CancelBy=@AccountNo where ApmNo = @ApmNo;
--		update  leg_Icon.dbo.tblprepaid set Balance=Balance +@totalCharge, ModifyDate =@currentDate
--													 where phoneno=@AccountNo;
													 
													 
--		insert tblAdjustment (AdjTypeID, AccountNo  ,LastBalance ,  AdjAmount  , AdjustDate ,  UserName ,   status)	
--						 values(9,@AccountNo, 	@lastBalance,	-@totalCharge,	@currentDate, 	@AccountNo,1)		;				 
--	    return 0;
--	 end
--	else
--		return -1;
--END

