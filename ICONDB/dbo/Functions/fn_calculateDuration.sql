

CREATE FUNCTION dbo.fn_calculateDuration (@dura int, @minDuration smallint, @minIncrement numeric(4,2))  
RETURNS varchar(6)  AS  
BEGIN 
	 declare  @tictac smallint,  @second smallint , @minute  smallint, @hour  smallint ,  @duration  int, @billableTime  varchar(6), @l  smallint, @f numeric(6,2)
	
	
	
	SET  @duration  =CEILING( @dura /60.00)
	If (  @duration <=  @minDuration Or  @duration = 0  )
		SET   @duration = @minDuration
	If(@minIncrement >1  and @duration > @minDuration )
	  Begin
		SET  @f = @duration / @minIncrement 
		SET @f = ceiling(@f)
		SET  @duration = @f *@minIncrement
	  End

	SET @billableTime  = CAST (@duration as varchar(4))
	SET @l = len(@billableTime)
	if( @l =1)  SET  @billableTime = '000' + @billableTime + '00'
	else if( @l =2)  SET  @billableTime = '00' + @billableTime + '00'
	else if( @l =3)  SET  @billableTime = '0' + @billableTime + '00'
	else  SET  @billableTime =  @billableTime + '00'
	return @billableTime
END












