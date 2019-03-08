-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_service_type_by_facility]
@facilityID int,
@TroubleID int
AS
BEGIN
	Declare @AgentID int;
	Set @AgentID =1; 
	Select @AgentID  = a.AgentID from tblTroubleType  a with(nolock) , tblfacility b with(nolock)  where a.agentID = b.AgentID and b.FacilityID = @facilityID
	
	 Select troubleID, Descript from tblTroubleType with(nolock) where AgentID =@AgentID;


END

