-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_list_AmtelFacility]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	select a.FTPfolderName, b.FacilityID from tblFacilityOption a with(nolock), tblFacility b  with(nolock) where a.FacilityID = b.FacilityID and b.AgentID =102 and b.status=1 and (FTPfolderName is not null) ;


END

