

CREATE PROCEDURE  [dbo].[sp_get_replycode] 
@replycode	char(3),
@billable	char  OUTPUT,
@description	varchar(100) OUTPUT
AS
SET NOCOUNT ON
SET @billable = ''
SELECT  @billable = billable,  @description  = [description]  FROM  tblreplycode   WHERE replycode = @replycode

If (@billable  =  ''   Or  @billable  is null   )
  begin
	SET @billable = 'N'
	SET @description = 'Denied '
  End
