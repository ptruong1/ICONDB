

CREATE FUNCTION dbo.fn_NumRec(@num  int)  
RETURNS char(6)  AS  
BEGIN 
	declare @l_num char(6)
	
	if( @num <10)  SET @l_num  = '00000' + cast (@num as char(1))
	else if( @num <100)  SET @l_num  = '0000' + cast (@num as char(2))
	else  if( @num <1000)  SET @l_num  = '000' + cast (@num as char(3))
	else  if( @num <10000)  SET @l_num  = '00' + cast (@num as char(4))
	else  if( @num <100000)  SET @l_num  = '0' + cast (@num as char(5))
	else    SET @l_num  =  cast (@num as char(6))
	return  @l_num
END












