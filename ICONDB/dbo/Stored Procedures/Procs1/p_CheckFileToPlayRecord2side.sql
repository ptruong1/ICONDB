-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].p_CheckFileToPlayRecord2side

@toNo varchar(12),
@OutsideNo      varchar(3) OUTPUT,
@Record2sides      varchar(3) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	
	set @OutsideNo  = ''
	set @Record2sides  = ''	
	 begin
		SELECT @Record2sides = I.ANIno FROM [dbo].[tblANIs] I where ANINo = @toNo
		and (select Record2SideOpt from tblfacilityOption F where I.facilityId = F.facilityID) = 1
		SELECT @OutsideNo = I.ANIno FROM [dbo].[tblANIs] I where ANINo = @toNo
		
	 end

END

