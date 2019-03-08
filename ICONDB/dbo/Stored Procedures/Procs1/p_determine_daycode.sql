
CREATE PROCEDURE [dbo].[p_determine_daycode]
@daycode tinyint  OUTPUT
 AS

Declare  @dw  tinyint , @h  tinyint 
SET @daycode =1
SET  @dw  = datepart(dw, getdate())
SET   @h    = datepart(hh, getdate()) 
select  @daycode   = daycode from tbldaycode with(nolock)   where [day] =   @dw  and hour =  @h

