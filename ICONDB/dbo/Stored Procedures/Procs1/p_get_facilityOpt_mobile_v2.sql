CREATE PROCEDURE [dbo].[p_get_facilityOpt_mobile_v2]
 @facilityID int
AS
BEGIN
	SET NOCOUNT ON;
	Declare @VideoVisitOpt bit, @EmailOpt bit, @VideoMessageOpt bit , @PictureOpt bit , @VisitRule varchar(15), @textOpt bit, @voiceMessageOpt bit, @DebitOpt as bit;
	SET @VideoVisitOpt =0;
	SET @EmailOpt =0; 
	SET @VideoMessageOpt =0;
	SET @PictureOpt =0;
	SET @VisitRule = '1';
	SET @textOpt =0;
	SET @voiceMessageOpt =0;
	SET @DebitOpt =0 ;
	select  @VideoVisitOpt  = isnull(VideoVisitOpt,0) , @EmailOpt= isnull(EmailOpt,0) ,  @VideoMessageOpt= Isnull(VideomessageOpt,0) , @PictureOpt = isnull(PictureOpt,0),@DebitOpt = isnull( DebitCardLessOpt,0)   from tblFacilityOption with(nolock) where FacilityID = @facilityID;
	Select @VisitRule = isnull(RuleName,'1') from  tblVisitFacilityConfig with(nolock) where FacilityID =@facilityID;

	SELECT @VideoVisitOpt as VideoVisitOpt,  @EmailOpt as EmailOpt,  @VideoMessageOpt as  VideoMessageOpt,  @PictureOpt as  PictureOpt,  @textOpt as TextOpt, @voiceMessageOpt  as voiceMessageOpt, @VisitRule as VisitRule, @DebitOpt as DebitOpt ;
END