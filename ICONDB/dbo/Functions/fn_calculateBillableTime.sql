

CREATE FUNCTION [dbo].[fn_calculateBillableTime] (@duration int, @minDuration smallint ,@minIncrement numeric(4,2))  
RETURNS int  AS  
BEGIN 
	declare  @tictac smallint,  @second smallint , @minute  smallint, @hour  smallint ,   @billableTime  varchar(6), @l  tinyint, @f numeric(8,2);
	Declare  @m int , @d int ;
	SET @m =  CEILING ( @duration/60.00) ;
	If(@minIncrement  = 0 or @minIncrement  is null) 
		set @minIncrement =1;
	If (  @m <=  @minDuration)
		SET  @m = @minDuration;
	If(@minIncrement >1  and @m > @minDuration )
	  Begin
		SET  @f = CAST(@m as numeric(8,2))/ @minIncrement ;
		SET @f = ceiling(@f);
		SET  @m  = @f *@minIncrement;
	  End

	return  @m  ;
END












