-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_ProfileId]
@VerificationId varchar(100),
@ProfileId     varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RemainCount int
	set @ProfileId = ''
		
	 begin
	 	 select @ProfileId=profileId from tblBioMetricProfileOxfordVerification with(nolock) where  profileId = @VerificationId ;
	 end

END


