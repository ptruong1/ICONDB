-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_facility_service_option]
@FacilityID int
AS
BEGIN
   SET NOCount ON;
	Declare @VideoVisitOpt bit, @FormsOpt bit, @VideoMessageOpt bit, @EmailOpt bit,  @PictureOpt bit, 	@PhoneOpt   bit , @LawLibraryOpt bit,  @CommissaryOpt bit, @HandbookOpt bit;
	Declare @EducationSuiteOpt as bit,  @CampusLibOpt as bit,  @BookStoreOpt as bit,@VoiceMessageOpt bit,
			 @SelfDevOpt as bit, @ReligionOpt as bit, @MediaOpt as bit, @MusicOpt as bit, @MovieOpt as bit;
	
	SET  @facilityID=0;
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
	select  @VideoVisitOpt =isnull(VideoVisitOpt,0), @VoiceMessageOpt = isnull(VoiceMessageOpt,0),
		  @FormsOpt =Isnull(FormsOpt,0) , @VideoMessageOpt= isnull(VideoMessageOpt,0) , @EmailOpt=isnull(EmailOpt,0)  ,
			@PictureOpt = isnull(PictureOpt,0) ,	@PhoneOpt= isnull(SoftphoneOpt,0), @LawLibraryOpt = isnull(LawLibOpt,0) ,
		  @CommissaryOpt = isnull(commissaryOpt,0),@MediaOpt =isnull( MediaOpt,0),  @HandbookOpt= isnull(HandbookOpt,0) from tblFacilityOption with(nolock) where FacilityID = @facilityID;
    
		
	if( @MediaOpt =1)
		select @BookStoreOpt= isnull(BookOpt,0), @educationSuiteOpt = isnull(EducationOpt,0), @CampusLibOpt=isnull(CampusLibOpt,0), @SelfDevOpt=isnull(SelfDevOpt,0), @ReligionOpt = isnull(religionOpt,0), @MusicOpt = isnull(MusicOpt,0) from tblFacilityMediaConfig with(nolock) where facilityID = @facilityID ;

	
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
			0 as LobbyKiosk;
END



