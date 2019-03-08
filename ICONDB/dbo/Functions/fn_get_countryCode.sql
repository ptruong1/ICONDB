
CREATE FUNCTION [dbo].[fn_get_countryCode] (@DNI varchar(15))  
RETURNS  varchar(3)  AS  
BEGIN 
	declare @countryCode varchar(3) ;
	SET @countryCode =   left(@DNI,1);
	if(select count(Code) From tblCountryCode    with(nolock)  WHERE Code =  @countryCode ) =  0 
	  Begin
		SET @countryCode =   left(@DNI,2);
		
		if(select count(Code) From tblCountryCode    with(nolock)  WHERE Code =  @countryCode ) =  0 
		  Begin
			SET @countryCode =   left(@DNI,3);
			
			if(select count(Code) From tblCountryCode    with(nolock)  WHERE Code =  @countryCode ) =  0 
				Return -1;
		  End
	  End
	Return  @countryCode;


END

