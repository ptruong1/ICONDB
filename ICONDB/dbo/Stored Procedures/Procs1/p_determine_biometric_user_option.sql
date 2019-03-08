-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_biometric_user_option]
@FacilityID int,
@InmateID	varchar(12),
@BiometricOpt smallint output
AS
BEGIN
	SET NOCOUNT ON;
	---- will add more for third party call 
	--if(select COUNT(*) from tblFacilityOption with(nolock) where FacilityID = @FacilityID and BioMetric=1) >0
	if( @InmateID <>'' and @InmateID <>'0' and @FacilityID in (352,686,689,670))
	 begin
		set @BiometricOpt =1;
	 end
	else
		set @BiometricOpt =0;

END

