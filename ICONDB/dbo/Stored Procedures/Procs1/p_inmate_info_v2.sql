CREATE PROCEDURE [dbo].[p_inmate_info_v2]
@facilityID int,
@PIN    varchar(12),    
@InmateID  varchar(12),    
@FullName         varchar(50),
@BirthDate  varchar(12),
@BookingNo  varchar(12),

@ArrestDate  varchar(12),
@ArrestTime  varchar(12),
@AgencyCaseNo   varchar(12),
@Agency        varchar(15),
@BookingDate varchar(12),
@BookingTime  varchar(12),
@Location          varchar(30),

@ChargeCode    varchar(12),
@ChargeDescript   varchar(200), 
@Level   varchar(20) ,
@CaseNo varchar(14) , 
@MODIFIER  varchar(30) , 
@BAILOUT	char(1), 
@BAILAMOUNT numeric(10,2) ,  
@COURT   	varchar(30),
@SentenceDate varchar(12),
@ReleaseDate varchar(12),
@SentenceDays varchar(40),

@HoldType           varchar(50),
@HoldStartDate   varchar(12),
@RemoveDate	varchar(12),

@VisitsRemaining	smallint,
@AccountBalance	numeric(7,2),
@CourtInfo		varchar(30),
@Judge		varchar(40),
@ApperanceDate	Varchar(20)

 AS
 declare @AtCurrLoc  varchar(30), @locationID int, @i int, @extID varchar(20), @VisitPerday tinyint , @VisitPerWeek tinyint, @VisitPerMonth tinyint;
 set @LocationID =0;
 SET @VisitPerday =1;
 SET @VisitPerWeek =4;
 SET @VisitPerMonth =10;
if(select count(*) from  tblInmateInfo with(nolock) where PIN =@PIN and FacilityID=@facilityID and BookingNo = @BookingNo) = 0
 begin
	insert  tblInmateInfo (BookingNo ,   PIN, facilityID  ,  FullName    , BirthDate ,     ArrestDate ,  ArrestTime, BookingDate,  BookingTime, AgencyCaseNo ,
			Agency  ,	  Location   ,HoldType  ,  HoldStartDate , InmateID)
	Values( @BookingNo  ,@PIN  ,@facilityID  ,  @FullName        ,@BirthDate  ,@ArrestDate ,@ArrestTime  ,@BookingDate ,@BookingTime ,@AgencyCaseNo   ,
		@Agency        ,@Location          ,@HoldType           ,@HoldStartDate, @InmateID   )
 end
if(@ChargeDescript <>'')
 begin
	if(select count(*) from  tblInmateBookInfo  with(nolock) where PIN =@PIN and FacilityID=@facilityID and BookingNo = @BookingNo and   ChargeCode = @ChargeCode ) = 0
	 begin
		Insert  tblInmateBookInfo  (PIN , FacilityID , BookingNO ,   ChargeCode ,  ChargeDescript   , Level   ,             CaseNo ,      MODIFIER   ,  BAILOUT, BAILAMOUNT,   COURT,SentenceDate, ReleaseDate, SentenceDays,Visits,Balance   ,Judge, ApperanceDate, InmateID )                      
	  		values(  @PIN, @facilityID, @BookingNo,@ChargeCode,   @ChargeDescript  , @Level  ,@CaseNo  , @MODIFIER  , @BAILOUT, @BAILAMOUNT , @CourtInfo,@SentenceDate, @ReleaseDate, @SentenceDays,@VisitsRemaining,  @AccountBalance,@Judge,@ApperanceDate , @InmateID )

	 end
	Else
	  Begin
		Update tblInmateBookInfo SET BAILOUT = @BAILOUT, BAILAMOUNT =  @BAILAMOUNT, COURT = @CourtInfo, SentenceDate = @SentenceDate ,Judge =@Judge , ApperanceDate  = @ApperanceDate 
			Where  PIN =@PIN and FacilityID = @facilityID  and BookingNo = @BookingNo and   ChargeCode = @ChargeCode
	  End 
 end
If ( select count(*) from tblInmateUpdate WHERE PIN =@PIN  and FacilityID =@facilityID) = 0
 Begin
	INSERT tblinmateUpdate ( PIN , FacilityID,  VisitNo    , ComBalance, AtLocation     ,   releaseDate,LastUpdate, InmateID)
		Values( @PIN, @facilityID , @VisitsRemaining	,@AccountBalance, @location, @ReleaseDate, getdate(),@InmateID)
 End
Else
 Begin
	Update  tblInmateUpdate SET VisitNo =  @VisitsRemaining	,
				       ComBalance = @AccountBalance,
				       AtLocation =   @location,
				       releaseDate = @ReleaseDate,
				       LastUpdate = getdate()
				 WHERE PIN =@PIN and FacilityID = @facilityID 
 End

if( @Location <>'' and @Location is not null)
Begin 

    select  @AtCurrLoc = isnull(AtLocation,''),@i= COUNT(*) from  tblVisitInmateConfig	with(nolock)
		where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
		
   select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
		and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId and ( LocationName = @Location  );
   if(@locationID =0 or @locationID is null )
		select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
		and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName like @Location + '%' );
   if(@locationID =0 or @locationID is null )
		select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
		and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  ( LocationName like '%' + @Location  + '%');
   
  if(@locationID =0 or @locationID is null )
		select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
		and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@Location ,3));
  if(@locationID =0 or @locationID is null )
		select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
		and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@Location ,4));
   if(@locationID =0 or @locationID is null )
		select @locationID =  a.LocationID FROM tblVisitLocation a with(nolock), tblVisitPhone b with(nolock) where a.facilityID = b.facilityID
		and a.LocationID = b.LocationID and b.StationType =2 and a.FacilityID = @facilityId  and  (LocationName = left(@Location ,10));
   
  
   if(@locationID =0 or @locationID is null )
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationType =2 and StationID   like '%'+  @Location  + '%' ;
   
   if(@locationID =0 or @locationID is null )
		select @locationID = isnull(locationID,0), @extID  = ExtID from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationType =2 and StationID = rtrim(substring(@Location,10,2))
		
	
   /*

   select @AtCurrLoc = isnull(AtLocation,''),@i= COUNT(*) from  tblVisitInmateConfig	with(nolock)
		where FacilityID =@facilityId and InmateID =@InmateID group by AtLocation ;
		
   select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName = @Location ;
   if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitLocation with(nolock) where FacilityID = @facilityId and LocationName like @Location + '%' ;
    if(@locationID =0)
		select @locationID = isnull(locationID,0) from tblVisitPhone  with(nolock) where FacilityID = @facilityId and StationID  like @Location + '%' ;
	*/	
   if (@i >0 ) 
    begin
		if (@AtCurrLoc <> @Location )
			update tblVisitInmateConfig set AtLocation = @Location, LocationID =@locationID, ModifyDate =getdate(), ExtID=@ExtID where FacilityID =@facilityId and InmateID =@InmateID;
	end
   else
    begin
	   if( @locationID is not null) 
	     begin
			select @VisitPerday = isnull(VisitPerDay,0), @VisitPerWeek= isnull(VisitPerWeek,0) , @VisitPerMonth= isnull(VisitPerMonth,0) from tblVisitFacilityConfig with(nolock) where FacilityID= @facilityID  	
			Insert leg_Icon.dbo.tblVisitInmateConfig (InmateID,FacilityID,AtLocation, LocationID, InputDate, ExtID, VisitPerDay, VisitPerWeek, VisitPerMonth)
					values(@InmateID ,@facilityId,@Location, @locationID, getdate(), @extID, @VisitPerday,@VisitPerWeek,@VisitPerMonth);
		 end
	end
end



