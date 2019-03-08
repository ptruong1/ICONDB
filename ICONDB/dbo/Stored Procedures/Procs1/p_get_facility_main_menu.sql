-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facility_main_menu]
@FacilityID int
AS
BEGIN
	if(select count(*) from tblFacilityMainMenu where facilityID = @FacilityID) =0
		begin
				if(select count(*) from tblFacilityOption where facilityID = @FacilityID and FormsOpt = 1) =0
					select * from tblFacilityMainMenu where facilityID =0;
				else
				select * from tblFacilityMainMenu where facilityID =1;
		
		end
	else
		begin
			select * from tblFacilityMainMenu where facilityID =@facilityID ;
			
		end
END

