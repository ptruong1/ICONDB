
CREATE PROCEDURE [dbo].[p_determine_daycode_by_Local]
@localTime datetime,
@daycode tinyint  OUTPUT
 AS

Declare  @dw  tinyint , @h  tinyint 
SET  @dw  = datepart(dw, @localTime)
SET   @h    = datepart(hh, @localTime) 
--select @h
select  @daycode   = daycode from tbldaycode with(nolock)   where [day] =   @dw  and hour =  @h

