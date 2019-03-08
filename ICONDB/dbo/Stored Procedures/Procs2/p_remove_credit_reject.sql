CREATE PROCEDURE [dbo].[p_remove_credit_reject]
@ccNo	varchar(16),
@Record	int output
AS

Delete  from tblTBRreject   where CCno = @ccNo

Set @Record	=@@ROWCOUNT
