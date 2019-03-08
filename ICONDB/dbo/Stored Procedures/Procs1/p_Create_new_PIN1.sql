
CREATE PROCEDURE [dbo].[p_Create_new_PIN1]
@MinLength	tinyint,
@PIN   varchar(12)  OUTPUT
AS

Declare @r1  varchar(12)
SET  @r1 = cast(cast(rand() * 1000000000000 as bigint) as varchar(12))

SET @PIN  =  right(@r1 ,@MinLength)

