CREATE PROCEDURE [dbo].[p_get_chat_server_info_v1] 
	@PhoneNo varchar(12)
AS
BEGIN
	declare @facilityID int
	select @facilityID = FacilityID from tblprepaid where PhoneNo = @PhoneNo
	SELECT FacilityID, ServerIP as TechnologyType, Description as ChatServerIP  from  tblVisitPhoneServer with(nolock) where facilityID = @facilityID	;
			   
END