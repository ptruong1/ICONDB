
CREATE FUNCTION [dbo].[f_get_AddresNo]
 (@Address varchar(50))  
RETURNS varchar(12)
AS  

BEGIN 
	Declare @AddresNo  varchar(12),  @i int
	SET @i = CHARINDEX(' ',@Address)
	if(@i>0)
		SET @AddresNo =  ltrim(substring (@Address,1, @i-1))
	else
		SET @AddresNo = '0'
	if( isnumeric(@AddresNo) =0 )
		 SET @AddresNo =  '000'
	return @AddresNo
 
END

