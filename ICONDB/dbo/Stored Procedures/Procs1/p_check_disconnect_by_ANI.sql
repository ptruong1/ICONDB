CREATE PROCEDURE [dbo].[p_check_disconnect_by_ANI]
@fromNo	varchar(10)

AS
DECLARE  @call_dis  tinyint
SET   @call_dis  = 0

SELECT   @call_dis = count(*)  FROM tblAMA    WHERE   fromNo= @fromNo  AND
								         (rtrim(projectCode) = '' Or projectCode is null) and	
								         -- connectdate = convert(char(6),getdate(),12)  AND
								         datediff(ss,inputDate,getdate()) <25


return  @call_dis
