-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_kiosk_facilityOpt_v1]
@FacilityID	int,
@DeviceTypeID tinyint,
@DeviceName		varchar(25),
@IPaddress  Varchar(16)
AS
BEGIN
   SET NOCount ON;
	Declare  @facilityName as varchar(200),@VideoVisitOpt bit, @VideoVisitSite varchar(300), @FormsOpt bit, @FormSite varchar(300), @AVSopt bit,
		    @VideoMessageOpt bit, @VideoMessageSite varchar(300), @EmailOpt bit, @EmailSite varchar(300), @PictureOpt bit, @PictureSite varchar(300),
			@PhoneOpt   bit , @LawLibraryOpt bit,@LawLibrarySite as varchar(300),  @CommissaryOpt bit,@CommissarySite nvarchar(200), @HandbookOpt bit, @HandbookFilename varchar(20);
	Declare @EducationSuiteOpt as bit, @EducationSuiteSite varchar(300), @CampusLibOpt as bit, @CampusSite varchar(300), @BookStoreOpt as bit, @BookStoreSite varchar(300),
			 @SelfDevOpt as bit, @SelfDevSite varchar(300), @ReligionOpt as bit,  @ReligionSite varchar(300), @MediaOpt as bit, @MusicOpt as bit, @MusicSite as varchar(300);
	
	SET @VideoVisitOpt =0;
	SET  @FormsOpt =0;
	SET  @VideoMessageOpt =0;
	SET @EmailOpt =0;
	SET @PictureOpt =0; 
	SET @PhoneOpt   =0;
	SET @LawLibraryOpt =0;
	SET  @CommissaryOpt =0;
	SET @CommissarySite ='';
	SET @EducationSuiteOpt =0;
	SET @EducationSuiteSite ='';
	SET @CampusLibOpt =0;
	SEt  @BookStoreOpt =0;
	SET @SelfDevOpt =0;
	SET @ReligionOpt =0;
	SET @MediaOpt =0;
	SET @LawLibrarySite ='';
	SET @MusicOpt =0;
	SET @MusicSite ='';
	SET @BookStoresite  ='';
	SET @VideoMessageSite ='';
	SET @VideoVisitSite ='';
	SET @FormSite  ='';
	SET @PictureSite  ='';
	SET  @EmailSite  ='';
	SET @SelfDevSite ='';
	SET  @ReligionSite  ='';
	SET @BookStoreSite  ='';
	SET @HandbookOpt =0;
	SET  @HandbookFilename ='1.pdf';
	SET  @CampusSite  = 'http://207.141.247.185/CampusLibary/inmateLogin';
    SET @AVSopt  =0;
select @facilityName = location + ' ' +  city + ' ' + State + ',' + Zipcode   from tblfacility with(nolock) where FacilityID = @facilityID;


if(@DeviceTypeID =1)
 begin
	SET @VideoVisitOpt =1;
 end
Else if (@DeviceTypeID =5 or @DeviceName like '%VRS%')
 begin
	SET @AVSopt =1;
 end
Else
Begin
    select  @VideoVisitOpt =isnull(VideoVisitOpt,0), 
	@FormsOpt =Isnull(FormsOpt,0) , @VideoMessageOpt= isnull(VideoMessageOpt,0) , @EmailOpt=isnull(EmailOpt,0)  ,
		@PictureOpt = isnull(PictureOpt,0) ,	@PhoneOpt= isnull(SoftphoneOpt,0), @LawLibraryOpt = isnull(LawLibOpt,0) ,
	@CommissaryOpt = isnull(commissaryOpt,0),@MediaOpt =isnull( MediaOpt,0),  @HandbookOpt= isnull(HandbookOpt,0),  @AVSopt = isnull(AVSopt,0) from tblFacilityOption with(nolock) where FacilityID = @facilityID;

		if( @CommissaryOpt =1)
			select @CommissarySite= Commsite  from tblfacilityCommissary  with(nolock) where facilityID = @facilityID and (KioskID = @DeviceName  or KioskID ='All');
		   --set @CommissarySite = 'http://portal15.swansons.net/ElkoNV_Kiosk/frmLanguageOptions.aspx?banker=sl0eko03&kioskstation=71&ShowScreensaver=2';
		if(@CommissarySite = '' or @CommissarySite is null)
			SET @CommissaryOpt =0;
		if( @MediaOpt =1)
			select @BookStoreOpt= isnull(BookOpt,0), @educationSuiteOpt = isnull(EducationOpt,0), @CampusLibOpt=isnull(CampusLibOpt,0), @SelfDevOpt=isnull(SelfDevOpt,0), @ReligionOpt = isnull(religionOpt,0), @MusicOpt = isnull(MusicOpt,0) from tblFacilityMediaConfig with(nolock) where facilityID = @facilityID 

		If( @CampusLibOpt =1) 
			SET  @CampusSite  = 'http://bcd.legacyinmate.com/LegacyCampusLibrary/';
		If( @SelfDevOpt =1) 
			SET @SelfDevSite = ' http://bcd.legacyinmate.com/LegacyTabletSelfImprovement/';
		If( @VideoVisitOpt =1) 
			SET @VideoVisitSite = 'http://legacyinmate.com/visitation/inmatelogin.aspx';
		If(  @EmailOpt =1) 
			SET @EmailSite = 'https://legacyinmate.com/LegacyMessagingNoKeypad/InmateForms/EmailMessages.aspx';
		If(@VideoMessageOpt =1) 
			SET @VideoMessageSite = 'https://legacyinmate.com/LegacyMessagingNoKeypad/InmateForms/VideoMessages.aspx';
		If(@formsOpt =1) 
			SET @FormSite = 'https://legacyinmate.com/visitationNokeypad/InmateForms/InmateFormsMenu.aspx';
	
      
		if (@educationSuiteOpt  =1)
			Select @EducationSuiteSite  = isnull([site],'') from tblFacilityEducationSuite with(nolock) where facilityID =@facilityID ;
		if(@LawLibraryOpt =1)
			select @LawLibrarySite = providerSite from tblFacilityLawLib with(nolock) where facilityID =@facilityID;
		if(@MusicOpt =1)
			Set @MusicSite = 'http://www.pandora.com/' ; --   // 'https://archive.org/details/etree';
		if(@ReligionOpt=1)
			set @religionSite = 'http://bcd.legacyinmate.com/LegacyTabletReligion/'
			--SET @religionSite = 'https://inmate.legacyicon.com/Default.aspx';
		if(@BookStoreOpt=1)
			SET @BookStoresite=' http://bcd.legacyinmate.com/Legacytabletbookstore/';
		If(@HandbookOpt=1)
			--set @HandbookFilename ='http://legacyinmate.com/LegacyHandbook/Default.aspx'
			SET @HandbookFilename = CAST(@facilityID as varchar(5)) + '.pdf';
		 If (@PictureOpt =1)
			SET @PictureSite = 'http://bcd.legacyinmate.com/LegacyMessagingPS_NotKeypad/InmateForms/PictureSharing.aspx';
 end			
	
-- New Config for Different Devices
-- turn on/off for testing



-----------------------


	 select @facilityID as FacilityID , @facilityName as FacilityName, 
			@VideoVisitOpt as VideoVisitOpt,  @VideoVisitSite as VideoVisitSite, 
			@FormsOpt as FormsOpt, @FormSite as FormSite,
			@VideoMessageOpt as  VideoMessageOpt, @VideoMessageSite as VideoMessageSite,
			@EmailOpt as EmailOpt, @EmailSite as EmailSite,
			@PictureOpt  as PictureOpt , @PictureSite as PictureSite,
			@PhoneOpt as PhoneOpt, 
			@LawLibraryOpt as LawLibraryOpt,@LawLibrarySite as LawLibrarySite,
			@CommissaryOpt as CommissaryOpt, @CommissarySite as CommissarySite,
			@BookStoreOpt as BookStoreOpt, @BookStoreSite as BookStoreSite,
			@educationSuiteOpt  as EducationSuiteOpt, @EducationSuiteSite  as  EducationSuiteSite,  
			@CampusLibOpt as CampusLibOpt, @CampusSite as CampusLibSite ,
			@SelfDevOpt as SelfDevOpt, @SelfDevSite as SelfDevSite,
			@ReligionOpt as ReligionOpt, @ReligionSite as ReligionSite, 
			@MusicOpt as MusicOpt, @MusicSite as MusicSite,
			@HandbookOpt as HandbookOpt, @HandbookFilename as HandbookFilename,
			@AVSopt as AVSopt ;
END



