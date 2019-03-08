-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_facility_service_option_v2]
@FacilityID int
AS
BEGIN
   SET NOCount ON;
	Declare @VideoVisitOpt bit, @FormsOpt bit, @VideoMessageOpt bit, @EmailOpt bit,  @PictureOpt bit, 	@PhoneOpt   bit , @LawLibraryOpt bit,  @CommissaryOpt bit, @HandbookOpt bit;
	Declare @EducationSuiteOpt as bit,  @CampusLibOpt as bit,  @BookStoreOpt as bit,@VoiceMessageOpt bit, 
			 @SelfDevOpt as bit, @ReligionOpt as bit, @MediaOpt as bit, @MusicOpt as bit, @MovieOpt as bit;
	Declare @Location varchar(50),@Address varchar(50),@City varchar(20), @State varchar(2), @Zipcode varchar(10),
			@Phone char(10), @ContactName varchar(50), @ContactPhone char(10), @ContactEmail varchar(30);
	Declare @AcctExeID tinyint, @AcctExeName varchar(25), @EmailE varchar(50),@BusPhoneE varchar(10), @CellPhoneE varchar(10),
			@AcctRepID tinyint, @AcctRepName varchar(25), @EmailR varchar(50), @BusPhoneR varchar(10), @CellPhoneR varchar(10)
	Declare @VisitContactEmail1 varchar(50),@VisitContactEmail2 varchar(50),@VisitContactEmail3 varchar(50)
		
	
	SET @VideoVisitOpt =0;
	SET  @FormsOpt =0;
	SET  @VideoMessageOpt =0;
	SET @EmailOpt =0;
	SET @PictureOpt =0; 
	SET @PhoneOpt   =0;
	SET @LawLibraryOpt =0;
	SET  @CommissaryOpt =0;

	SET @EducationSuiteOpt =0;
	
	SET @CampusLibOpt =0;
	SEt  @BookStoreOpt =0;
	SET @SelfDevOpt =0;
	SET @ReligionOpt =0;
	SET @MediaOpt =0;
	SET @MusicOpt =0;
	SET @HandbookOpt =0;
	SET @MovieOpt =0;
	SET @voiceMessageOpt =0
	select 
	    @VideoVisitOpt =isnull(VideoVisitOpt,0), 
	    @VoiceMessageOpt = isnull(VoiceMessageOpt,0),
		@FormsOpt =Isnull(FormsOpt,0), 
		@VideoMessageOpt= isnull(VideoMessageOpt,0),
		@EmailOpt=isnull(EmailOpt,0),
		@PictureOpt = isnull(PictureOpt,0),	
	    @PhoneOpt= isnull(SoftphoneOpt,0), 
	    @LawLibraryOpt = isnull(LawLibOpt,0) ,
		@CommissaryOpt = isnull(commissaryOpt,0),
		@MediaOpt =isnull( MediaOpt,0),  
		@HandbookOpt= isnull(HandbookOpt,0),
		@Location = ISNULL(Location,''),
		@Address = isnull(Address, ''),
		@City =ISNULL(City,''),
		@State =ISNULL(State,''),
		@Zipcode =ISNULL(Zipcode, ''),
		@Phone =ISNULL(Phone, ''),
		@ContactName = ISNULL(ContactName, ''),
		@ContactPhone = ISNULL(F.ContactPhone,''),
		@ContactEmail = ISNULL(F.ContactEmail, ''),
		@AcctExeName = ISNULL(AcctExeName, ''),
		@AcctExeID = ISNULL(E.AcctExeID, 0),
		@AcctRepID = ISNULL(R.AcctRepID,0),
		@BusPhoneE =ISNULL(E.BusPhone, ''),
		@CellPhoneE = ISNULL(E.CellPhone, ''),
		@EmailE = ISNULL(E.Email,''),
		@AcctRepName =ISNULL(R.AcctRepName,''),
		@BusPhoneR =ISNULL(R.BusPhone,''),
		@CellPhoneR = ISNULL(R.CellPhone,''),
		@EmailR = ISNULL(R.Email,''),
		@VisitContactEmail1 = ISNULL(V.ContactEmail, ''),
		@VisitContactEmail2 = ISNULL(V.ContactEmail2, ''),
		@VisitContactEmail3 = ISNULL(V.ContactEmail3, '')
		
		   From tblFacility  F with(nolock)
			left join tblFacilityOption O with(nolock) on F.FacilityID = O.facilityID
			left join tblAccountExecutive E with (nolock) on isnull(F.AcctExeID,15) = E.AcctExeID
			left join tblAccountRepresentative R with (nolock) on isnull(F.AcctRepID,15) = R.AcctRepID
			left join tblVisitFacilityConfig V with(nolock) on F.FacilityID = V.facilityID
		where O.FacilityID = @facilityID;
    
		
	if( @MediaOpt =1)
		select @BookStoreOpt= isnull(BookOpt,0), 
			   @educationSuiteOpt = isnull(EducationOpt,0), 
			   @CampusLibOpt=isnull(CampusLibOpt,0), 
			   @SelfDevOpt=isnull(SelfDevOpt,0), 
			   @ReligionOpt = isnull(religionOpt,0), 
			   @MusicOpt = isnull(MusicOpt,0) 
			   from tblFacilityMediaConfig with(nolock) where facilityID = @facilityID ;

	
-----------------------

	 select @facilityID as FacilityID , 
			1 as Phone,
			1 as PhoneVisit,
			@VoiceMessageOpt as VoiceMessage,
			@VideoVisitOpt as VideoVisit,
			@FormsOpt as KiteForms,
			@VideoMessageOpt as  VideoMessage,
			@EmailOpt as Email,
			@PictureOpt  as PictureSharing , 
			@LawLibraryOpt as LawLibrary,
			@CommissaryOpt as Commissary ,
			@BookStoreOpt as Bookstore,
			@educationSuiteOpt  as EducationSuite, 
			@CampusLibOpt as CampusLibrary,
			@SelfDevOpt as SelfDevelopment,
			@ReligionOpt as Religion, 
			@MusicOpt as Music, 
			@HandbookOpt as Handbook,
			0 as LobbyKiosk,
			@Location as Location,
			@Address as Address,
			@City as City,
			@State as State,
			@Zipcode as Zipcode,
			@Phone as Phone,
			@ContactName as ContactName,
			@ContactPhone as ContactPhone,
			@ContactEmail as ContactEmail,
			@AcctExeID as AcctExeID,
			@AcctRepID as AcctRepID,
			@AcctExeName as AcctExeName,
			@BusPhoneE as AcctExeBusPhone,
			@CellPhoneE as AcctExeCellPhone,
			@EmailE as AcctExeEmail,
			@AcctRepName as AcctRepName,
			@BusPhoneR as AcctRepBusPhone,
			@CellPhoneR as AcctRepCellPhone ,
			@EmailR as AcctRepEmail,
			@VisitContactEmail1 as VisitContactEmail1,
			@VisitContactEmail2 as VisitContactEmail2,
			@VisitContactEmail3 VisitContactEmail3
		
			
END



