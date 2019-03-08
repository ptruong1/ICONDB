

CREATE FUNCTION dbo.fn_CalculateChargeAmt
 (@firstMinute  smallmoney, @addMinute smallmoney,@connectFee smallmoney , @billableTime varchar(6) , @callType  varchar(2), @Pip smallmoney, @minDuration tinyint)
RETURNS   varchar(7) AS  
BEGIN 
	Declare  @duration smallint, @chargeAtm  varchar(7) , @charge  numeric(6,2) , @i tinyint, @pre varchar(4), @scale varchar(2)
	 SET @duration = CAST (@billableTime  as smallint)/100
	--IF @duration  <= @minDuration
		--SET @charge = @firstMinute  + (@minDuration -1) *  @addMinute 
	--ELSE

	IF (@firstMinute = 0 )
	  Begin
		IF (@duration > @minDuration )   SET @charge =( @duration - @minDuration ) *  @addMinute 
		else   SET @charge = 0
	   end
	Else  	SET @charge =  @firstMinute  + (@duration - 1) *  @addMinute 
	SET  @charge = @charge + @connectFee +  @pip
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
	
	SET  @chargeAtm = Convert (varchar(7), @charge )
	SET @i = charindex('.', @chargeAtm ,1)
	SET @pre = left(@chargeAtm , @i-1)
	If(len(@pre) =1 )  SET @pre = '000' + @pre
	ELSE  If(len(@pre) =2 )  SET @pre = '00' + @pre
	ELSE  If(len(@pre) =3 )  SET @pre = '0' + @pre
	SET @scale = right(@chargeAtm,2)
	
	RETURN   @pre + @scale
END








