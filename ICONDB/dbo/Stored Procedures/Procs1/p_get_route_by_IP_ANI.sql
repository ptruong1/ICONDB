-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_route_by_IP_ANI]
	@IPaddress varchar(18),
	@ANI		varchar(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @ACP varchar(18), @AgentID int;
	SET @ACP ='';
	SET @AgentID =0;
    select  @ACP= b.IpAddress from  tblFacilityATAInfo a with(nolock) , tblACPs b with(nolock)  where a.routeID = b.Id and a.ATAIP= @Ipaddress;
	if( @ACP ='') 
		select @AgentID = AgentID from tblfacility a with(nolock) , tblANIs b with(nolock) where a.FacilityID = b.facilityID and b.ANINo = @ANI;
	If(@AgentID >0)
		SET @ACP = '172.20.30.21';

	Select @ACP as ACPAddress;
END

