
CREATE PROCEDURE  [dbo].[P_Update_PrepaidAccount_SetStatus]

@PhoneNo char(10),
@status		tinyint  
AS

SET NOCOUNT ON;

update     tblPrepaid  set 
	       	tblPrepaid.Status = @status 		
WHERE  tblPrepaid.PhoneNo = @PhoneNo

