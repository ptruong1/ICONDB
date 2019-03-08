-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_response_email_by_service_type]
@facilityID int,
@troubleID tinyint
AS
BEGIN
	Declare @AgentID int;
	Set @AgentID =1; 
	Select @AgentID  = a.AgentID from tblTroubleType  a with(nolock) , tblfacility b with(nolock)  where a.agentID = b.AgentID and b.FacilityID = @facilityID
	 Select ResponseEmail from tblTroubleType with(nolock) where AgentID =@AgentID and TroubleID = @troubleID;


END

