CREATE PROCEDURE [dbo].[p_remove_CC_reject]
@CCno  varchar(16)
AS
	
delete  from  tblTBRreject where  ccno = @CCno 
