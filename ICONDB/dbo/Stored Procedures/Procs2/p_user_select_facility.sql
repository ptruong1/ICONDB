
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_user_select_facility]
@stateID	smallint
AS
BEGIN
	SET NOCOUNT ON;
	Select FacilityID, Location from tblfacility a with(nolock) inner join tblStates b with(nolock) on (a.State =b.StateCode)
	Where b.StateID =@stateID and a.status=1 ;
	
END


