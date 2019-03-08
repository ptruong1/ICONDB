
CREATE PROCEDURE [dbo].[p_inmate_info_v3]  --- This sp is using for Fresno only

@PIN    varchar(12),    
@BookingNo  varchar(12),    
@FullName         varchar(50),
@BirthDate  varchar(12),
@Sex   char(1),
@Race    varchar(10),
@HairColor  varchar(8),
@EyeColor  varchar(8),
@Height   varchar(10),
@Weight  smallint,
@Age	smallint,

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
@ApperanceDate	Varchar(20),

@EntityID	varchar(20),
@VisitorName	varchar(70),
@Gender			varchar(6),
@Phone			varchar(12),
@Address		varchar(100)

 AS

Declare @LocationID as int, @CurrentLocation varchar(30), @CurrentRemainVisit smallint, @firstName varchar(25), @lastName varchar(25) ;
SET  @LocationID =0;
SET @CurrentLocation = '';
SET @firstName = substring ( @FullName, CHARINDEX(',',@FullName)+1, len( @FullName));
SET @lastName= ltrim(substring ( @FullName,1, CHARINDEX(',', @FullName)-1));
if(select count(*) from  tblInmateInfo with(nolock) where PIN =@PIN and BookingNo = @BookingNo) = 0
 begin
	insert  tblInmateInfo (BookingNo ,   PIN, facilityID  ,  FullName    , BirthDate ,  Sex , Race  ,   HairColor, EyeColor  , Height  ,     Weight ,Age,    ArrestDate ,  ArrestTime, BookingDate,  BookingTime, AgencyCaseNo ,
			Agency  ,	  Location   ,HoldType  ,  HoldStartDate, InmateID )
	Values( @BookingNo  ,@PIN  ,352  ,  @FullName        ,@BirthDate  ,@Sex  ,@Race    ,@HairColor  ,@EyeColor ,@Height      ,@Weight ,@Age	,@ArrestDate ,@ArrestTime  ,@BookingDate ,@BookingTime ,@AgencyCaseNo   ,
		@Agency        ,@Location          ,@HoldType           ,@HoldStartDate, @PIN   );
 end
--Booking Info
if(select count(*) from  tblInmateBookInfo  with(nolock) where PIN =@PIN and BookingNo = @BookingNo and   ChargeCode = @ChargeCode ) = 0
 begin
    if(@ChargeCode <>'0' and @ChargeCode <>'' and len(@ChargeDescript) >4)
		Insert  tblInmateBookInfo  (PIN , FacilityID , BookingNO ,   ChargeCode ,  ChargeDescript   , Level   ,             CaseNo ,      MODIFIER   ,  BAILOUT, BAILAMOUNT,   COURT,SentenceDate, ReleaseDate, SentenceDays,Visits,Balance   ,Judge, ApperanceDate, InmateID )                      
	  	values(  @PIN, 352, @BookingNo,@ChargeCode,   @ChargeDescript  , @Level  ,@CaseNo  , @MODIFIER  , @BAILOUT, @BAILAMOUNT , @CourtInfo,@SentenceDate, @ReleaseDate, @SentenceDays,@VisitsRemaining,  @AccountBalance,@Judge,@ApperanceDate, @PIN  );

 end
Else
  Begin
	Update tblInmateBookInfo SET BAILOUT = @BAILOUT, BAILAMOUNT =  @BAILAMOUNT, COURT = @CourtInfo, SentenceDate = @SentenceDate ,Judge =@Judge , ApperanceDate  = @ApperanceDate 
		Where  PIN =@PIN and BookingNo = @BookingNo and   ChargeCode = @ChargeCode;
  End 
  
--Update commissary  
If ( select count(*) from tblInmateUpdate WHERE FacilityID = 352 and PIN =@PIN ) = 0
 Begin
	INSERT tblinmateUpdate ( PIN , FacilityID,  VisitNo    , ComBalance, AtLocation     ,   releaseDate,LastUpdate, InmateID)
		Values( @PIN, 352, @VisitsRemaining	,@AccountBalance, @location, @ReleaseDate, getdate(), @PIN);
 End
Else
 Begin
	Update  tblInmateUpdate SET VisitNo =  @VisitsRemaining	,
				       ComBalance = @AccountBalance,
				       AtLocation =   @location,
				       releaseDate = @ReleaseDate,
				       LastUpdate = getdate()
				 WHERE PIN =@PIN ;
 End

if(select count(*) from  tblinmate  with(nolock) where PIN =@PIN and facilityId =352) = 0
  Begin
	INSERT tblinmate(  InmateID  , LastName , FirstName,  Status ,DateTimeRestrict,  AlertEmail  ,   AlertPhone, AlertCellPhones,FacilityId,  UserName ,PIN   )                                            
	Values( @PIN , @lastName,@firstName,1, 0,'','','',352,'admin',@PIN);
  End
Else
  begin
	 Update  tblinmate set [status]=1 , modifydate =getdate() where PIN =@PIN and facilityId =352;
  end

-- update location and for visiting

select  @locationID = locationID from tblVisitLocation with(nolock) where facilityid =352 and LocationName like '%' + left(@location,6) +  '%' ;

if( left(@location,6) ='AJ, 03')
	SET @LocationID = 7627;
if(@locationID is null)
	SET @locationID =0 ;
Select @CurrentLocation = Atlocation,@CurrentRemainVisit =VisitRemain  from tblVisitInmateConfig  with(nolock) where InmateID =@PIN and facilityId =352 ;
if (@CurrentLocation = '')
 begin
	insert tblVisitInmateConfig (FacilityID ,LocationID,AtLocation,InmateID, VisitRemain,VisitPerDay , VisitPerWeek , VisitPerMonth  )
			values(352,@locationID, @Location,@PIN,@VisitsRemaining,2,2,10)  --- Need to edit here 9/19/2016
 end
 else
  begin
	-- if(@CurrentLocation <> @Location)
		update tblVisitInmateConfig  set VisitRemain = @VisitsRemaining,AtLocation=@Location,LocationID= @LocationID, modifyDate = getdate() where facilityID =352 and InmateID= @PIN
	-- else
		--if(@CurrentRemainVisit <>  @VisitsRemaining)
		--	update tblVisitInmateConfig  set VisitRemain = @VisitsRemaining where facilityID =352 and InmateID= @PIN;
  end 

  if(@EntityID <>'0' and @EntityID <>'')
   begin
		if(len(@VisitorName) > 3)
		 begin
			Declare @VFirstName varchar(25), @VLastName varchar(25);
			SET @VLastName =rtrim( left(@VisitorName, charindex(',',@VisitorName)-1));
			SET @VFirstName =ltrim(right(@VisitorName, len(@VisitorName) - charindex(',',@VisitorName)));
		 end
		if(select count(entityID) from tblvisitors with(nolock) where entityID = @entityID) =0
		 begin
			declare  @nextID int;
			EXEC   p_create_nextID 'tblVisitors', @nextID   OUTPUT;
			 
			insert tblvisitors (facilityID, vLastName,VfirstName, phone1, entityID,enduserID,InmateID,recordOpt,relationshipID,username,Approved,stateID, VisitorID) values (352, @VLastName ,@VFirstName ,@phone,@entityID,@phone,@pin,'Y',99,'file','Y',5,@nextID);
		 end
		else
		 begin
			if(@phone <>'NA' and @phone <>'' and ISNUMERIC(@phone) =1)
				update tblvisitors set Phone1 = @phone,EndUserID=@Phone where facilityID =352 and entityID = @entityID;
		 end
		if((@phone <>'NA' and @phone <>'' and ISNUMERIC(@phone) =1) and (select count(phoneno) from tblprepaid with(nolock) where phoneno= @phone) =0)
			INSERT tblprepaid (phoneno,facilityID, firstname,lastname,stateID,countryID,relationshipID)
				values(@phone,352,@vFirstname,@vLastname,5,203,99);
   end


