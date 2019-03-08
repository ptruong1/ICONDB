
CREATE FUNCTION [dbo].[fn_ConvertSecToMin] ( @duration int)  
RETURNS varchar(8)  AS  
BEGIN 
	Declare  @m int , @d int, @h int, @dur  varchar(8) , @c_m varchar(2),  @c_d varchar(2), @c_h varchar(2);
	SET @h =  @duration/3600;
	if(@h >=1)
	 begin
		Set @duration =  @duration%3600 ;
		SET @m =  @duration/60;
		SEt  @d =  @duration%60;
		if(@h <9)
			SET  @c_h = '0' + cast(@h as varchar(2));
		else 
			SET  @c_h = cast(@h as varchar(2));
	 end
	else
	 begin
		SET @m =  @duration/60;
		SEt  @d =  @duration%60;
		SET  @c_h ='00';
	 end
	If(@m > 9) SET  @c_m  =cast(@m as varchar(2)) ;
	Else SET   @c_m  = '0' + cast(@m as varchar(2)) ;
	If( @d >9) SET  @c_d  =  cast(@d as varchar(2));
	Else   SET @c_d  = '0'+  cast(@d as varchar(2));
	
	SET  @dur  =  @c_h +':' + @c_m + ':' +@c_d;
	
	return @dur ;
	
END












