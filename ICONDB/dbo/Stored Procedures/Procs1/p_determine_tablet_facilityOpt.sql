-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_tablet_facilityOpt]
@tabletName	Varchar(15),
@IPaddress  Varchar(16)
AS
BEGIN
   SET NOCount ON;
 
	 SET NOCount ON;
	Declare @facilityID int, @MediaOpt bit, @facilityName as varchar(200),@VideoVisitOpt bit, @FormsOpt bit, @VideoMessageOpt bit, @EmailOpt bit, @PictureOpt bit,@PhoneOpt   bit ,@LawLibraryOpt bit, @CommissaryOpt bit,@CommissarySite nvarchar(200);
	Declare @BookOpt bit, @MovieOpt bit, @MusicOpt bit, @VocationalOpt bit, @EducationOpt bit, @EducationSite varchar(50);
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
	SET @BookOpt =0;
	SET  @MovieOpt =0;
	SET  @MusicOpt=0 ;
	SET  @VocationalOpt =0; 
	SET  @EducationOpt =0;
	SET  @EducationSite ='';
    select @facilityID=facilityID from  tbltablets with(nolock) where TabletID =@tabletName;

	if(@facilityID >0)
	begin
		select @facilityName = location + ' ' +  city + ' ' + State + ',' + Zipcode   from tblfacility with(nolock) where FacilityID = @facilityID;
		select  @VideoVisitOpt =isnull(VideoVisitOpt,0), @MediaOpt = isnull(mediaOpt,0),
			@FormsOpt =Isnull(FormsOpt,0) , @VideoMessageOpt= isnull(VideoMessageOpt,0) , @EmailOpt=isnull(EmailOpt,0)  ,
			 @PictureOpt = isnull(PictureOpt,0) ,	@PhoneOpt= isnull(SoftphoneOpt,0), @LawLibraryOpt = isnull(LawLibOpt,0) ,
			@CommissaryOpt = isnull(commissaryOpt,0) from tblFacilityOption with(nolock) where FacilityID = @facilityID;
   
	   if(@MediaOpt =1)
			Select @BookOpt= isnull(bookopt,0) , @MovieOpt= isnull(MovieOpt,0), @MusicOpt = isnull(musicOpt,0), @VocationalOpt = isnull(vocationalOpt,0),
			 @EducationOpt = isnull(educationOpt,0) from tblfacilitymediaconfig with(nolock) where facilityID =@facilityID; 		


		if( @CommissaryOpt =1)
		  select @CommissarySite= Commsite  from tblfacilityCommissary  with(nolock) where facilityID = @facilityID and (KioskID = @tabletName  or KioskID ='All');
		if(@EducationOpt =1)
			SET @EducationSite = 'https://corrections.learnedovo.com';

		if(@CommissarySite = '' or @CommissarySite is null)
			SET @CommissaryOpt =0;
	 end
     select @facilityID as FacilityID , @facilityName as FacilityName, @VideoVisitOpt as VideoVisitOpt, @FormsOpt as FormsOpt, @VideoMessageOpt as  VideoMessageOpt,
			@EmailOpt as EmailOpt, @PictureOpt  as PictureOpt , @PhoneOpt as PhoneOpt, @LawLibraryOpt as LawLibraryOpt,
			@CommissaryOpt as CommissaryOpt, @CommissarySite as CommissarySite,  @BookOpt as BookOpt, @MovieOpt as MovieOpt , 
			@MusicOpt as MusicOpt, @VocationalOpt as VocationalOpt,  @EducationOpt as EducationOpt, @EducationSite as EducationSite ;
END

