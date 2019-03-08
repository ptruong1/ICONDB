CREATE FUNCTION [dbo].[fn_CalculateCallRevenue_v2]  
 (@firstMinute  smallmoney, @addMinute smallmoney,@connectFee smallmoney , @billableTime smallint , @callType  varchar(2), @totalSurcharge  smallmoney)
RETURNS   Numeric(5,2) AS  
BEGIN 
	--@billableTime is in Minute calculated by fn_calculateBillabeTime
	Declare    @charge  numeric(6,2);
	If (@billableTime = 0)
	 begin
	   	 SET  @charge = 0;	
	   	 return @charge;
	end
	
	SET @charge =  @firstMinute  + (@billableTime - 1) *  @addMinute  ;
	SET  @charge = @charge + @connectFee +  @totalSurcharge;
	IF(@callType = 'IN'  )
	  Begin
		If @charge  > 250
			SET @charge = 250;
	  End
	Else
	  Begin
		If @charge  > 124.99
			SET @charge = 124.99;
	  End
	
	return @charge;
END













