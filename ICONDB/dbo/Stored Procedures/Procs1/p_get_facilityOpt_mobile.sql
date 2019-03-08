-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facilityOpt_mobile]
 @facilityID int
AS
BEGIN
	Declare @VideoVisitOpt bit, @EmailOpt bit, @VideoMessageOpt bit , @PictureOpt bit , @VisitRule varchar(15), @textOpt bit, @voiceMessageOpt bit;
	SET @VideoVisitOpt =0;
	SET @EmailOpt =0; 
	SET @VideoMessageOpt =0;
	SET @PictureOpt =0;
	SET @VisitRule = '1';
	SET @textOpt =0;
	SET @voiceMessageOpt =0;
	select  @VideoVisitOpt  = isnull(VideoVisitOpt,0) , @EmailOpt= isnull(EmailOpt,0) ,  @VideoMessageOpt= Isnull(VideomessageOpt,0) , @PictureOpt = isnull(PictureOpt,0)  from tblFacilityOption where FacilityID = @facilityID;
	Select @VisitRule = isnull(RuleName,'1') from  tblVisitFacilityConfig with(nolock) where FacilityID =@facilityID;
	SELECT @VideoVisitOpt as VideoVisitOpt,  @EmailOpt as EmailOpt,  @VideoMessageOpt as  VideoMessageOpt,  @PictureOpt as  PictureOpt,  @textOpt as TextOpt, @voiceMessageOpt  as voiceMessageOpt ;
END


