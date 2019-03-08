
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_user_select_state]
@CountryID int
AS
BEGIN
	SET NOCOUNT ON;
	select  StateID, StateName  from tblStates  with(nolock)  where (CountryID = @CountryID or CountryID is null) order by StateID ;
	

END


