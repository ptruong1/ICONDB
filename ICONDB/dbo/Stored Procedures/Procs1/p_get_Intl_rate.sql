
CREATE PROCEDURE [dbo].[p_get_Intl_rate] 
@rateID	varchar(7),
@DNI		varchar(18),
@ConnectFee	numeric(6,4)  OUTPUT,
@FirstMinute	numeric(6,4)  OUTPUT,
@NextMinute	numeric(6,4)  OUTPUT,
@toState	char(2)         OUTPUT,
@toCity	            char(10)  Output

AS

Declare @countryCode varchar(4)
set @ConnectFee =0
set @FirstMinute	 =0
set @NextMinute =0
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
SELECT  @firstMinute = firstMinute, @connectFee= connectFee,  @nextMinute =Nextminute , @toState=left(Descript,2),  @toCity = left(Descript,10)
FROM tblIntlRate   with(nolock)  WHERE RateID =  @rateID  AND (CountryCode =  @countryCode or CountryCode ='011')
If(   @firstMinute = 0 and @connectFee =0 and  @nextMinute =0 )
	SELECT  @firstMinute = firstMinute, @connectFee= connectFee,  @nextMinute =Nextminute , @toState=left(Descript,2),  @toCity = left(Descript,10)
	FROM tblIntlRate   with(nolock)  WHERE RateID =  'J9'  AND CountryCode ='011' -- modify for all  @countryCode

If(   @firstMinute = 0 and @connectFee =0 and  @nextMinute =0 ) 
  Begin
	set @FirstMinute	 =4.75
	set @NextMinute =4.75
	set @toState ='NA'
	set  @toCity  ='Unknown'
  End

