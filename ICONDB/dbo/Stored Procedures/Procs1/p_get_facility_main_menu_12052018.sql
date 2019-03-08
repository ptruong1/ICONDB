-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[p_get_facility_main_menu_12052018]
@FacilityID int
AS
BEGIN
	if(select count(*) from tblFacilityMainMenu where facilityID = @FacilityID) =0
		begin
				if(select count(*) from tblFacilityOption where facilityID = @FacilityID and FormsOpt = 1) =0
					select FacilityID, FacilityConfig, UserControl, PhoneConfig, CallControl, Debit, Inmate, Report, CallAnalysis, Message, Visitation, ServiceRequest, Kite from tblFacilityMainMenu where facilityID =0;
				else
				select FacilityID, FacilityConfig, UserControl, PhoneConfig, CallControl, Debit, Inmate, Report, CallAnalysis, Message, Visitation, ServiceRequest, Kite from tblFacilityMainMenu where facilityID =1;
		
		end
	else
		begin
			select FacilityID, FacilityConfig, UserControl, PhoneConfig, CallControl, Debit, Inmate, Report, CallAnalysis, Message, Visitation, ServiceRequest, Kite from tblFacilityMainMenu where facilityID =@facilityID ;
			
		end
END

