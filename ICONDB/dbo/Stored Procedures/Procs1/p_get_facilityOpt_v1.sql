-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facilityOpt_v1]
 @facilityID int
AS
BEGIN
	Declare @VideoVisitOpt bit, @EmailOpt bit, @VideoMessageOpt bit , @PictureOpt bit , @VisitRule varchar(15);
	SET @VideoVisitOpt =0;
	SET @EmailOpt =0; 
	SET @VideoMessageOpt =0;
	SET @PictureOpt =0;
	SET @VisitRule = '1';
	select  @VideoVisitOpt  = isnull(VideoVisitOpt,0) , @EmailOpt= isnull(EmailOpt,0) ,  @VideoMessageOpt= Isnull(VideomessageOpt,0) , @PictureOpt = isnull(PictureOpt,0)  from tblFacilityOption where FacilityID = @facilityID;
	Select @VisitRule = isnull(RuleName,'1') from  tblVisitFacilityConfig with(nolock) where FacilityID =@facilityID;
	SELECT @VideoVisitOpt as VideoVisitOpt,  @EmailOpt as EmailOpt,  @VideoMessageOpt as  VideoMessageOpt,  @PictureOpt as  PictureOpt, @VisitRule as VisitRule ;
END



