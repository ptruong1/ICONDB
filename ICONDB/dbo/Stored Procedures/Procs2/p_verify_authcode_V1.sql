-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_verify_authcode_V1]
@UserName varchar(20),
@Authcode int,
@ReturnCode as int OUTPUT
AS
BEGIN
	--If (select max(activeDate) from tblusersecondfactor where username = @UserName and authcode= @Authcode  and DATEDIFF (minute, activeDate, getdate()) <15) > 0
	-- begin
	--		set @ReturnCode = 1
	-- end
	--else
	-- begin
	--	set @ReturnCode = 0
	-- end
	if @AuthCode = (SELECT TOP 1 AuthCode FROM tblusersecondfactor where username = @UserName 
		and DATEDIFF (minute, activeDate, getdate()) <15 ORDER BY activeDate DESC) 
		 begin
			set @ReturnCode = 1
		 end
	else
	begin
			set @ReturnCode = 0
		 end
END

