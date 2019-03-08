CREATE PROCEDURE [dbo].[p_verify_ResetPassordLink] 
	@id uniqueidentifier
AS
if (select COUNT(*) from tblResetPassword where TempPassword = @id and RequestDate >  DATEADD(HOUR, -1,GETDATE())) >0
   begin
	Select 1 as isValid
   end
else
   begin
		Select 0 as isValid
   end

