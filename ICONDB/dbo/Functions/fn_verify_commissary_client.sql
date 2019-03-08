-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_verify_commissary_client]
(
	@clientID varchar(10),
	@SiteID		int,
	@SystemID	varchar(12)
)
RETURNS varchar(2)
AS
BEGIN
	if(select count(*) from tblClientUsers where clientID= @clientID and siteID = @SiteID and username= @SystemID) =0 
	begin
		if(select count(*) from tblClientUsers where clientID= @clientID) =0
			return '1';
		if(select count(*) from tblClientUsers where siteID = @SiteID) =0
			return '2';
		else
			return '3';
	end
	if(@@ERROR <>0)
		return '99';
	return '0';
	
END
