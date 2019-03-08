CREATE PROCEDURE  [dbo].[p_remove_collect_call_Threshold1]
@billtono	varchar(10)
AS
IF (SELECT Count(billtono)  FROM tblcallsbilled WHERE tono=@billtono and billtype='01')  = 0
	RETURN -1;
else
	update tblcallsbilled set complete=2 where tono=@billtono and billtype='01'
