
CREATE FUNCTION dbo.fn_CalculateCallRevenue
 (@firstMinute  smallmoney, @addMinute smallmoney,@connectFee smallmoney , @duration varchar(7) , @callType  varchar(2), @totalSurcharge  smallmoney, @minDuration tinyint)
RETURNS   Numeric(5,2) AS  
BEGIN 
	Declare   @chargeAtm  varchar(7) , @charge  numeric(6,2) , @i tinyint, @pre varchar(4), @scale varchar(2) ,@billableTime  int
	 SET @billableTime =  CEILING(CAST ( @duration  as int)/60.00)
	If @billableTime = 0
	   	 SET  @charge = 0
	ELSE IF @billableTime  <= @minDuration
		SET @charge = @firstMinute  + (@minDuration -1) *  @addMinute 
	ELSE
		SET @charge =  @firstMinute  + (@billableTime - 1) *  @addMinute  
	SET  @charge = @charge + @connectFee +  @totalSurcharge
	IF(@callType = 'IN'  )
	  Begin
		If @charge  > 250
			SET @charge = 250
	  End
	Else
	  Begin
		If @charge  > 124.99
			SET @charge = 124.99
	  End
	
	return @charge
END













