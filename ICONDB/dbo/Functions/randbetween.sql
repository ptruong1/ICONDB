-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create function dbo.randbetween(@bottom integer, @top integer)
returns integer
as
begin
   return (select cast(round((@top-@bottom)* RandomNumber +@bottom,0) as integer) from dbo.vRandomNumber)
end
