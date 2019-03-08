-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_kiosk_facilityOpt_old]
@KioskName	Varchar(15),
@IPaddress  Varchar(16)
AS
BEGIN
   SET NOCount ON;
   /*
	Declare @facilityID int, @facilityName as varchar(200);
	SET  @facilityID=0;
	select @facilityID=facilityID from tblVisitPhone  with(nolock) where ExtID =@KioskName;
	if(@facilityID =0)
		  select @facilityID=facilityID from  tblfacilitykiosk with(nolock) where KioskName =@KioskName;
	select @facilityName = location + ' ' +  city + ' ' + State + ',' + Zipcode   from tblfacility with(nolock) where FacilityID = @facilityID;
	select @facilityID as FacilityID ,@facilityName as FacilityName, isnull(VideoVisitOpt,0) as VideoVisitOpt, 
	 Isnull(FormsOpt,0) as FormsOpt , isnull(VideoMessageOpt,0) as  VideoMessageOpt, isnull(EmailOpt,0)  as EmailOpt, isnull(PictureOpt,0) as  PictureOpt ,
	 isnull(SoftphoneOpt,0) as PhoneOpt , isnull(LawLibOpt,0) as LawLibraryOpt,
	 isnull(commissaryOpt,0) as CommissaryOpt,
	 ( CASE  isnull(commissaryOpt,0) when 0 then '' else (select isnull(Commsite,'') from tblfacilityCommissary where facilityID = @facilityID) End ) CommissarySite
	   from tblFacilityOption with(nolock) where FacilityID = @facilityID;

	 --Need to add commissary field
	 -- Select * from tblfacilityCommissary
	 */
	 SET NOCount ON;
	Declare @facilityID int, @facilityName as varchar(200),@VideoVisitOpt bit, @VideoVisitSite varchar(300), @FormsOpt bit, @FormSite varchar(300),
		    @VideoMessageOpt bit, @VideoMessageSite varchar(300), @EmailOpt bit, @EmailSite varchar(300), @PictureOpt bit, @PictureSite varchar(300),
			@PhoneOpt   bit , @LawLibraryOpt bit,@LawLibrarySite as varchar(300),  @CommissaryOpt bit,@CommissarySite nvarchar(200), @HandbookOpt bit, @HandbookFilename varchar(20);
	Declare @EducationSuiteOpt as bit, @EducationSuiteSite varchar(300), @CampusLibOpt as bit, @CampusSite varchar(300), @BookStoreOpt as bit, @BookStoreSite varchar(300),
			 @SelfDevOpt as bit, @SelfDevSite varchar(300), @ReligionOpt as bit,  @ReligionSite varchar(300), @MediaOpt as bit, @MusicOpt as bit, @MusicSite as varchar(300);
	
	SET  @facilityID=0;
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
	select @facilityID=facilityID from tblVisitPhone  with(nolock) where ExtID =@KioskName;
	if(@facilityID =0)
		  select @facilityID=facilityID from  tblfacilitykiosk with(nolock) where KioskName =@KioskName;
    if(@facilityID =0) 
		  select @facilityID=facilityID from  leg_Icon.dbo.tblTablets  with(nolock) where TabletID =@KioskName;
	select @facilityName = location + ' ' +  city + ' ' + State + ',' + Zipcode   from tblfacility with(nolock) where FacilityID = @facilityID;
	select  @VideoVisitOpt =isnull(VideoVisitOpt,0), 
		@FormsOpt =Isnull(FormsOpt,0) , @VideoMessageOpt= isnull(VideoMessageOpt,0) , @EmailOpt=isnull(EmailOpt,0)  ,
		 @PictureOpt = isnull(PictureOpt,0) ,	@PhoneOpt= isnull(SoftphoneOpt,0), @LawLibraryOpt = isnull(LawLibOpt,0) ,
		@CommissaryOpt = isnull(commissaryOpt,0),@MediaOpt =isnull( MediaOpt,0),  @HandbookOpt= isnull(HandbookOpt,0) from tblFacilityOption with(nolock) where FacilityID = @facilityID;

	if( @CommissaryOpt =1)
	  select @CommissarySite= Commsite  from tblfacilityCommissary  with(nolock) where facilityID = @facilityID and (KioskID = @KioskName  or KioskID ='All');

	if(@CommissarySite = '' or @CommissarySite is null)
		SET @CommissaryOpt =0;
	if( @MediaOpt =1)
		select @BookStoreOpt= isnull(BookOpt,0), @educationSuiteOpt = isnull(EducationOpt,0), @CampusLibOpt=isnull(CampusLibOpt,0), @SelfDevOpt=isnull(SelfDevOpt,0), @ReligionOpt = isnull(religionOpt,0), @MusicOpt = isnull(MusicOpt,0) from tblFacilityMediaConfig with(nolock) where facilityID = @facilityID 

	 If( @CampusLibOpt =1) 
		SET  @CampusSite  = 'http://207.141.247.185/LegacyCampusLibrary';
     If( @SelfDevOpt =1) 
		SET @SelfDevSite = 'http://207.141.247.185/LegacySelfImprovement';
     If( @VideoVisitOpt =1) 
		SET @VideoVisitSite = 'http://legacyinmate.com/visitation/inmatelogin.aspx';
      If(  @EmailOpt =1) 
		SET @EmailSite = 'http://legacyinmate.com/LegacyMessaging/InmateForms/emailmessages.aspx';
	  If(@VideoMessageOpt =1) 
		SET @VideoMessageSite = 'http://legacyinmate.com/LegacyMessaging/InmateForms/Videomessages.aspx';
	  If(@formsOpt =1) 
		SET @FormSite = 'http://legacyinmate.com/Visitation/InmateForms/InmateFormsMenu.aspx';
      
	 if (@educationSuiteOpt  =1)
		Select @EducationSuiteSite  = isnull([site],'') from tblFacilityEducationSuite with(nolock) where facilityID =@facilityID ;
	 if(@LawLibraryOpt =1)
		select @LawLibrarySite = providerSite from tblFacilityLawLib with(nolock) where facilityID =@facilityID;
	 if(@MusicOpt =1)
		Set @MusicSite ='https://archive.org/details/etree';
     if(@ReligionOpt=1)
		SET @religionSite = 'http://207.141.247.185/LegacyReligion';
	 if(@BookStoreOpt=1)
		SET @BookStoresite='http://207.141.247.185/legacybook/';

     If(@HandbookOpt=1)
		SET @HandbookFilename = CAST(@facilityID as varchar(5)) + '.pdf';
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
			@HandbookOpt as HandbookOpt, @HandbookFilename as HandbookFilename ;
END



