
CREATE PROCEDURE [dbo].[p_Create_new_PIN]
@PIN   varchar(12)  OUTPUT
AS

Declare @r1  varchar(14)

SET @r1=    cast(cast(rand() * 1000000 as int) as varchar(7))

 If ( len(@r1 ) = 5 )
	SET @PIN   ='10' +  @r1
 If ( len(@r1 ) = 6 )
	SET @PIN   ='1' +  @r1
else 
	SET @PIN  = @r1

