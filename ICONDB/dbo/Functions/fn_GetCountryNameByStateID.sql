CREATE FUNCTION dbo.fn_GetCountryNameByStateID(@StateID smallint)  
RETURNS varchar(50)   
AS   
-- Returns the stock level for the product.  
BEGIN  
    DECLARE @ret varchar(50);  
	select @ret = CountryName from tblCountryCode where CountryID = (select CountryID from tblStates where StateID = @StateID)
    RETURN @ret;  
END; 