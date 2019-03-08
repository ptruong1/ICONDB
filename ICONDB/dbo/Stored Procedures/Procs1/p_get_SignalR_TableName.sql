-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_SignalR_TableName]

@facilityID int,
@AgentID int,
@SignalRTableName      varchar(100) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
		set @SignalRTableName = ''
	IF @FacilityID > 0
	 begin
	 select @SignalRTableName=TableName from tblFacilityACP with(nolock) where  facilityID = @facilityID  ;
	 
	 end
	 else
	 Begin
	 select @SignalRTableName=TableName from tblFacilityACP with(nolock) where  AgentID = @AgentID  ;
	 End

	
	

END

