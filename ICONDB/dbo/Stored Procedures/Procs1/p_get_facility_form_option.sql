-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facility_form_option]
@FacilityID int
AS
BEGIN
	if(select count(*) from tblFacilityMainMenu where facilityID = @FacilityID) =0
		begin
				if(select count(*) from tblFacilityOption where facilityID = @FacilityID and FormsOpt = 1) =0
					select  Kite from tblFacilityMainMenu where facilityID =0;
				else
				select Kite from tblFacilityMainMenu where facilityID =1;
		
		end
	else
		begin
			select  Kite from tblFacilityMainMenu where facilityID =@facilityID ;
			
		end
END

