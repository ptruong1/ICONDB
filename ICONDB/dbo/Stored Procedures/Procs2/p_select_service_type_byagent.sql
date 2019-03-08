-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_service_type_byagent]
@AgentID int
AS
BEGIN
		
	 Select troubleID, Descript from tblTroubleType with(nolock) where AgentID =@AgentID;


END

