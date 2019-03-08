
CREATE FUNCTION [dbo].[fn_comp_string] (@s1  varchar(25),  @s2  varchar(25))  
RETURNS int AS  
BEGIN 
	IF(len(@s1) <> len(@s2)  )
		Return -1
	DECLARE @position int
	
	SET @position = 1
	WHILE @position <= len(@s1)
	   BEGIN
	       IF( UNICODE(SUBSTRING(@s1, @position, 1))  <>  UNICODE(SUBSTRING(@s2, @position, 1))  )
		Return -1
	       SET @position = @position + 1
	   END
	return 1
END
