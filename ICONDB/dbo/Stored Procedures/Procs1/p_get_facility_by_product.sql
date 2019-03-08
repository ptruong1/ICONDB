-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facility_by_product] 
	@State varchar(2),
	@ProductType smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@ProductType =1 )
     begin
		SELECT FacilityID, Location   from tblFacility with(nolock)  where state = @State 
			order by [State], Location
	 end
	else if(@ProductType =2)
	 begin	
		SELECT a.FacilityID, Location   from tblFacility a with(nolock)  , tblFacilityOption b with(nolock) where state = @State 
			and a.FacilityID = b.FacilityID
			and b.VisitRegReq =1
			order by [State], Location
	 end
	else if(@ProductType =4)
	 begin
		SELECT a.FacilityID, Location   from tblFacility a with(nolock)  , tblFacilityOption b with(nolock) where state = @State 
			and a.FacilityID = b.FacilityID
			and b.EmailOpt  =1
			order by [State], Location
	 end
	else if(@ProductType =5)
	 begin
		SELECT a.FacilityID, Location   from tblFacility a with(nolock)  , tblFacilityOption b with(nolock) where state = @State 
			and a.FacilityID = b.FacilityID
			and b.VoiceMessageOpt   =1
			order by [State], Location
	 end
	else if(@ProductType =6)
	 begin
		SELECT a.FacilityID, Location   from tblFacility a with(nolock)  , tblFacilityOption b with(nolock) where state = @State 
			and a.FacilityID = b.FacilityID
			and b.VideoMessageOpt    =1
			order by [State], Location
	 end
	else if(@ProductType =7)
	 begin
		SELECT a.FacilityID, Location   from tblFacility a with(nolock)  , tblFacilityOption b with(nolock) where state = @State 
			and a.FacilityID = b.FacilityID
			and b.PictureOpt    =1
			order by [State], Location
	 end
END

