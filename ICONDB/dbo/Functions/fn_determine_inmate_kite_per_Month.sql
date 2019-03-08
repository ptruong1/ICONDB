-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_inmate_kite_per_Month]
(
	@FacilityID int,
	@InmateID varchar(12),
	@FormType tinyint,
	@PerMonth smallint
)
RETURNS tinyint
AS
BEGIN
	if(@FormType =1)
	 begin
			 If(select  count(*)  from tblInmateRequestForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(MONTH,  RequestDate )  = DATEPART (MONTH, getdate()) and datepart(YEAR,  RequestDate )  = DATEPART (YEAR, getdate())) >= @PerMonth  
				return 3;
	 end
	if(@FormType =2)
	 begin
			 If(select  count(*)  from tblMedicalKiteForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(MONTH,  RequestDate )  = DATEPART (MONTH, getdate()) and datepart(YEAR,  RequestDate )  = DATEPART (YEAR, getdate())) >= @PerMonth  
				return 3;
	 end
    if(@FormType =3)
	 begin
			 If(select  count(*)  from tblGrievanceForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(MONTH, GrievanceReportTime )  = DATEPART (MONTH, getdate()) and datepart(YEAR,  GrievanceReportTime )  = DATEPART (YEAR, getdate())) >=@PerMonth 
				return 3;
	 end
    if(@FormType =4)
	 begin
			 If(select  count(*)  from tblInmateLegalRequest where FacilityID = @FacilityID and InmateID = @InmateID and datepart(MONTH, RequestDate)  = DATEPART (MONTH, getdate()) and datepart(YEAR,  RequestDate )  = DATEPART (YEAR, getdate())) >=@PerMonth 
				return 3;
	 end
  Return 0;
	
END
