-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_inmate_kite_per_Week]
(
	@FacilityID int,
	@InmateID varchar(12),
	@FormType tinyint,
	@PerWeek smallint
)
RETURNS tinyint
AS
BEGIN
	if(@FormType =1)
	 begin
			 If(select  count(*)  from tblInmateRequestForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(WEEK,  RequestDate )  = DATEPART (WEEK, getdate()) and datepart(YEAR, RequestDate )  = DATEPART(YEAR, getdate())) >= @PerWeek 
				return 2;
	 end
	if(@FormType =2)
	 begin
			 If(select  count(*)  from tblMedicalKiteForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(WEEK,  RequestDate )  = DATEPART (WEEK, getdate()) and datepart(YEAR, RequestDate )  = DATEPART(YEAR, getdate())) >= @PerWeek 
				return 2;
	 end
    if(@FormType =3)
	 begin
			 If(select  count(*)  from tblGrievanceForm where FacilityID = @FacilityID and InmateID = @InmateID and datepart(WEEK, GrievanceReportTime )  = DATEPART (WEEK, getdate()) and datepart(YEAR, GrievanceReportTime )  = DATEPART(YEAR, getdate())) >=@PerWeek 
				return 2;
	 end
    if(@FormType =4)
	 begin
			 If(select  count(*)  from tblInmateLegalRequest where FacilityID = @FacilityID and InmateID = @InmateID and datepart(WEEK, RequestDate)  = DATEPART (WEEK, getdate()) and datepart(YEAR, RequestDate )  = DATEPART(YEAR, getdate())) >= @PerWeek 
				return 2;
	 end
  Return 0;
	
END
