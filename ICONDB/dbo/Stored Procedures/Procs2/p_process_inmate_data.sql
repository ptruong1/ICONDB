
CREATE PROCEDURE [dbo].[p_process_inmate_data]
@InmateID	varchar(12),
@PIN	varchar(12),
@firstName	varchar(25),
@lastName	varchar(25),
@MidName	varchar(20),
@status		tinyint,
@facilityFolder	varchar(20),
@AtLocation	varchar(20),
@ReleaseDate varchar(12),
@AccountBalance numeric(10,2)

AS
SET NOCOUNT ON
Declare @facilityId int, @flatform int, @sendStatus tinyint, @autoPin tinyint, @AtCurrLoc varchar(20), @i tinyint, @locationID int, @curLocationID int;
set @facilityId =1;
SET @flatform = 2;
SET @sendStatus =0;
SET @autoPin =0;
SET @AtCurrLoc ='';
SET @locationID =0;
SET @curLocationID =0;
select @facilityId = FacilityID ,@sendStatus= isnull(inmateStatus,0),@autoPin= isnull(autoPin ,0) from tblFacilityOption with(nolock)  where FTPfolderName = @facilityFolder	;

--print @sendStatus
If(@InmateID='0' or @InmateID='' )
	Return 0;

if(@AtLocation <>'')
Begin 
   select @AtCurrLoc = isnull(AtLocation,''),@i= COUNT(AtLocation)  from  tblVisitInmateConfig	with(nolock)
		where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
	
	select  @curLocationID =LocationID  from  tblVisitInmateConfig	with(nolock)
		where FacilityID =@facilityId and InmateID =@InmateID  ;
		
   select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName = @AtLocation ;
   if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName like @AtLocation + '%' ;
   if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName like '%' + @AtLocation  ;
      if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName like '%' + @AtLocation + '%'  ;
   if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationID = @AtLocation;
    if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationID  like @AtLocation + '%' ;
	if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationID  like '%' +  @AtLocation ;
	--if(@locationID =0 and @facilityId=577) 
		--SET @locationID =7480;		
   if (@i >0 ) 
    begin
		if ((@AtCurrLoc <> @AtLocation ) or(@curLocationID <> @locationID and  @locationID >0))
		 begin
			update tblVisitInmateConfig set AtLocation = @AtLocation, LocationID =@locationID where FacilityID =@facilityId and InmateID =@InmateID;
			Update tblVisitEnduserSchedule  set LocationID = @locationID , Note ='Inmate Moved'  where FacilityID =@facilityId and InmateID =@InmateID;
		 end
	end
   else
    begin   	
		Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation,LocationID, InputDate)
					values(@InmateID ,@facilityId,@AtLocation,@locationID, getdate());
	end
end

if (@autoPin =0)
	exec [leg_Icon].[dbo].[p_process_inmate_data_with_PIN] 
		@InmateID	,	@PIN	,	@firstName	,	@lastName	,	@MidName	,
		@status		,	@facilityId,	@sendStatus,	@AtLocation	,	@ReleaseDate ,	@AccountBalance ;

else
	exec [leg_Icon].[dbo].[p_process_inmate_data_with_autoPIN1]
		@InmateID	,	@PIN	,	@firstName	,	@lastName	,	@MidName	,
		@status		,	@facilityId,	@sendStatus ;


