
CREATE PROCEDURE [dbo].[p_inmate_info]

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
@ApperanceDate	Varchar(20)

 AS


if(select count(*) from  tblInmateInfo with(nolock) where PIN =@PIN and BookingNo = @BookingNo) = 0
 begin
	insert  tblInmateInfo (BookingNo ,   PIN, facilityID  ,  FullName    , BirthDate ,  Sex , Race  ,   HairColor, EyeColor  , Height  ,     Weight ,Age,    ArrestDate ,  ArrestTime, BookingDate,  BookingTime, AgencyCaseNo ,
			Agency  ,	  Location   ,HoldType  ,  HoldStartDate )
	Values( @BookingNo  ,@PIN  ,352  ,  @FullName        ,@BirthDate  ,@Sex  ,@Race    ,@HairColor  ,@EyeColor ,@Height      ,@Weight ,@Age	,@ArrestDate ,@ArrestTime  ,@BookingDate ,@BookingTime ,@AgencyCaseNo   ,
		@Agency        ,@Location          ,@HoldType           ,@HoldStartDate   )
 end
--Booking Info
if(select count(*) from  tblInmateBookInfo  with(nolock) where PIN =@PIN and BookingNo = @BookingNo and   ChargeCode = @ChargeCode ) = 0
 begin
	Insert  tblInmateBookInfo  (PIN , FacilityID , BookingNO ,   ChargeCode ,  ChargeDescript   , Level   ,             CaseNo ,      MODIFIER   ,  BAILOUT, BAILAMOUNT,   COURT,SentenceDate, ReleaseDate, SentenceDays,Visits,Balance   ,Judge, ApperanceDate )                      
	  	values(  @PIN, 352, @BookingNo,@ChargeCode,   @ChargeDescript  , @Level  ,@CaseNo  , @MODIFIER  , @BAILOUT, @BAILAMOUNT , @CourtInfo,@SentenceDate, @ReleaseDate, @SentenceDays,@VisitsRemaining,  @AccountBalance,@Judge,@ApperanceDate  )

 end
Else
  Begin
	Update tblInmateBookInfo SET BAILOUT = @BAILOUT, BAILAMOUNT =  @BAILAMOUNT, COURT = @CourtInfo, SentenceDate = @SentenceDate ,Judge =@Judge , ApperanceDate  = @ApperanceDate 
		Where  PIN =@PIN and BookingNo = @BookingNo and   ChargeCode = @ChargeCode
  End 
  
--Update commissary  
If ( select count(*) from tblInmateUpdate WHERE PIN =@PIN ) = 0
 Begin
	INSERT tblinmateUpdate ( PIN , FacilityID,  VisitNo    , ComBalance, AtLocation     ,   releaseDate,LastUpdate)
		Values( @PIN, 352, @VisitsRemaining	,@AccountBalance, @location, @ReleaseDate, getdate())
 End
Else
 Begin
	Update  tblInmateUpdate SET VisitNo =  @VisitsRemaining	,
				       ComBalance = @AccountBalance,
				       AtLocation =   @location,
				       releaseDate = @ReleaseDate,
				       LastUpdate = getdate()
				 WHERE PIN =@PIN
 End

if(select count(*) from  tblinmate  with(nolock) where PIN =@PIN and facilityId =352) = 0
  Begin
	INSERT tblinmate(  InmateID  , LastName , FirstName,  Status ,DateTimeRestrict,  AlertEmail  ,   AlertPhone, AlertCellPhones,FacilityId,  UserName ,PIN   )                                            
	Values( @PIN , ltrim(substring ( @FullName,1, CHARINDEX(',', @FullName)-1)),( substring ( @FullName, CHARINDEX(',',@FullName)+1, len( @FullName))),1, 0,'','','',352,'admin',@PIN)
  End
Else
  begin
	 Update  tblinmate set [status]=1 , modifydate =getdate() where PIN =@PIN and facilityId =352
  end
