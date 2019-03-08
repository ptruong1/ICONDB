-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_onsite_visiting_location_by_inmate]
(
	@FacilityID int,
	@InmateID varchar(12)
)
RETURNS int
AS
BEGIN
	Declare @VisitLocationID int, @InmateAtLocation varchar(20);
	SET @InmateAtLocation ='';
	SET @VisitLocationID =0;
	if( select count( LocationID) from tblvisitlocation with(nolock)  where FacilityID = @FacilityID and LocationTypeID =1   group by facilityID having count( LocationID) >1 ) >0
	 begin
		select @InmateAtLocation = isnull(Atlocation,'')  from tblVisitInmateConfig  where FacilityID = @FacilityID and InmateID = @InmateID;
		if(@InmateAtLocation <> '')
			Select @VisitLocationID  = locationID from tblvisitLocation where FacilityID = @FacilityID and LocationTypeID =1  and LocationName like @InmateAtLocation ;
		if(@VisitLocationID =0 and @FacilityID=352)
			Select @VisitLocationID  = locationID from tblvisitLocation where FacilityID = @FacilityID and LocationTypeID =1 and LocationName like '%'+ left(@InmateAtLocation,1) + '%';
	 end
    return @VisitLocationID ;
END
