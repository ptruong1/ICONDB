-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_inmate_kite_per_day]
(
	@FacilityID int,
	@InmateID varchar(12),
	@FormType tinyint,
	@PerDay smallint
)
RETURNS tinyint
AS
BEGIN
	if(@FormType =1)
	 begin
			 If(select  count(*)  from tblInmateRequestForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(DAYOFYEAR,  RequestDate )  = DATEPART (DAYOFYEAR, getdate()) and DATEPART(YEAR,RequestDate) = DATEPART(YEAR,getdate())) >= @PerDay
				return 1;
	 end
	if(@FormType =2)
	 begin
			 If(select  count(*)  from tblMedicalKiteForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(DAYOFYEAR,  RequestDate )  = DATEPART (DAYOFYEAR, getdate()) and DATEPART(YEAR,RequestDate) = DATEPART(YEAR,getdate())) >= @PerDay
				return 1;
	 end
    if(@FormType =3)
	 begin
			 If(select  count(*)  from tblGrievanceForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(DAYOFYEAR, GrievanceReportTime )  = DATEPART (DAYOFYEAR, getdate()) and DATEPART(YEAR,GrievanceReportTime) = DATEPART(YEAR,getdate())) >= @PerDay
				return 1;
	 end
    if(@FormType =4)
	 begin
			 If(select  count(*)  from tblInmateLegalRequest where FacilityID = @FacilityID and InmateID = @InmateID and datepart(DAYOFYEAR, RequestDate)  = DATEPART (DAYOFYEAR, getdate()) and DATEPART(YEAR,RequestDate) = DATEPART(YEAR,getdate())) >= @PerDay
				return 1;
	 end
  Return 0;
	
END
