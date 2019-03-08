
CREATE FUNCTION dbo.[fn_determine_countryCode] (@DNI varchar(14))  
RETURNS  varchar(4)  AS  
BEGIN 
	declare @countryCode varchar(4) 
	SET @countryCode =   SUBSTRING(@DNI,4,1)
	if(select count(CountryCode) From tblIntlRate   with(nolock)  WHERE CountryCode =  @countryCode ) =  0 
	  Begin
		SET @countryCode =   SUBSTRING(@DNI,4,2)
		
		if(select count(CountryCode) From tblIntlRate   with(nolock)  WHERE CountryCode =  @countryCode ) =  0 
		  Begin
			SET @countryCode =   SUBSTRING(@DNI,4,3)
			
			if(select count(CountryCode) From tblIntlRate   with(nolock)  WHERE CountryCode =  @countryCode ) =  0 
				Return -1
		  End
	  End
	Return  @countryCode


END

