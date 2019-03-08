-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_identify_facility_by_kiosk] 
	@KioskName varchar(16)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
   Declare  @facilityID int,  @FacilityName varchar(100), @FacilityState varchar(30), @VideoVisitRemoteOpt tinyint,  @VideoVisitOnsiteOpt tinyint, @VideoMessageOpt tinyint, @EmailOpt tinyint, @visitOpt tinyint;
   Set @facilityID =0;
   SET @FacilityName ='';
   SET @FacilityState='';
   SET @VideoVisitRemoteOpt =0;
   SET @VideoVisitOnsiteOpt =0;
   SET @VideoMessageOpt =0;
   SET  @EmailOpt =0;
   select @facilityID= facilityID from tblFacilityKiosk with(nolock) where KioskName = @KioskName;
   if( @facilityID >0)
    begin
		select @FacilityName=Location ,@FacilityState = [state]  from tblFacility with(nolock) where facilityID = @facilityID ;
		select @visitOpt = VisitOpt from tblVisitFacilityConfig ith(nolock) where facilityID = @facilityID ;
		if(@visitOpt  =1)
			SET @VideoVisitRemoteOpt =1;
		else if (@visitOpt  =2)
			SET @VideoVisitOnsiteOpt =1;
		else if (@visitOpt  =3)
		 begin
			SET @VideoVisitRemoteOpt =1;
			SET @VideoVisitOnsiteOpt =1;
		 end
	end
	select    @facilityID  as facilityID,  @FacilityName as  FacilityName , @FacilityState as  FacilityState , @VideoVisitRemoteOpt as VideoVisitRemoteOpt , @VideoVisitOnsiteOpt as VideoVisitOnsiteOpt , @VideoMessageOpt as VideoMessageOpt, @EmailOpt as EmailOpt;
 
 End
 

 
 

