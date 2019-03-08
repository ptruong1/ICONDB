
CREATE PROCEDURE [dbo].[p_get_wireless_providers]
as
SET NOCOUNT ON;
	select WirelessName, Email_ext from tblWirelessProviders  with(nolock) 
