
CREATE PROCEDURE [dbo].[p_get_new_AccountNo]
@AccountNo   varchar(12)  OUTPUT
AS

Declare @r1  varchar(14)

SET @r1=    cast(cast(rand() * 1000000000000 as bigint) as varchar(14))

if(len(@r1 ) >11)
	SET @AccountNo    = right(@r1,12)
else If ( len(@r1 ) =11 )
	SET @AccountNo  = @r1 + '0'
else If ( len(@r1 ) =10 )
	SET @AccountNo  = @r1 + '00'
else If ( len(@r1 ) =9 )
	SET @AccountNo  = @r1 + '000' 
else If ( len(@r1 ) =8 )
	SET @AccountNo  ='0' +  @r1 + '000' 
else If ( len(@r1 ) =7 )
	SET @AccountNo  ='00' +  @r1 + '000' 
else If ( len(@r1 ) =6 )
	SET @AccountNo  ='000' +  @r1 + '000'

