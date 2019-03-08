-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_number_station] 
(
	@FacilityID int,
	@locationID int,
	@PodID   varchar(10),
	@visitType tinyint
)
RETURNS smallint
AS
BEGIN
	Declare @NoStation smallint, @LocStation smallint, @PodStation smallint, @VisitorStation smallint ;
	SET @NoStation =0;
	SET @LocStation =0;
	SET @PodStation =0;
	SET @VisitorStation =0;
	

	if(@visitType =1)
	 begin
		select  @VisitorStation = count(*) from tblvisitphone where FacilityID = @FacilityID and StationType =1  and [status]=1;
		if(@locationID > 0)
			Select  @LocStation =  count(*) from tblvisitphone where FacilityID = @FacilityID and LocationID = @locationID and StationType =2 and [status]=1;
		else
			Select  @LocStation =  count(*) from tblvisitphone where FacilityID = @FacilityID and  StationType =2  and [status]=1;

		if(@LocStation > @VisitorStation )
			SET @NoStation =  @VisitorStation;
		else
			SET @NoStation = @LocStation;			
	 end
	else
	 begin
		if(@locationID > 0)
			Select  @NoStation =  count(*) from tblvisitphone where FacilityID = @FacilityID and LocationID = @locationID and StationType =2 and [status]=1;
		else
			Select  @NoStation = count(*) from tblvisitphone where FacilityID = @FacilityID and  StationType =2  and [status]=1;

	 end


	Return @NoStation;
END
