-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_facilityOpt]
 @facilityID int
AS
BEGIN
	select  isnull(VideoVisitOpt,0) as VideoVisitOpt,  isnull(EmailOpt,0)  as EmailOpt, Isnull(VideomessageOpt,0) as VideoMessageOpt, isnull(PictureOpt,0) as  PictureOpt    from tblFacilityOption where FacilityID = @facilityID;
END

