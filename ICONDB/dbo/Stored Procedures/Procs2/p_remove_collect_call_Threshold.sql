CREATE PROCEDURE  [dbo].[p_remove_collect_call_Threshold]
@billtono	varchar(10)
AS

update tblcallsbilled set complete=2 where tono=@billtono and billtype='01'
