CREATE PROCEDURE [dbo].[p_get_chat_server_info] 
	@FacilityID int
AS
BEGIN

	SELECT FacilityID, ServerIP as TechnologyType, Description as ChatServerIP  from  tblVisitPhoneServer with(nolock) where facilityID =@facilityID	;
			   
END