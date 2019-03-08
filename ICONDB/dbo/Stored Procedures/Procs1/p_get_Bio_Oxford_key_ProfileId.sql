-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_key_ProfileId]

@facilityID int,
@DivID int,
@userid varchar(16),
@MicrosoftKey      varchar(100) OUTPUT,
@ProfileId      varchar(100) OUTPUT,
@RemainEnrollments int output
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint,  @RemainCount int
	set @MicrosoftKey = ''
	set @ProfileId = ''
	set @RemainEnrollments = 9
	
	 begin
	 select @MicrosoftKey=VoiceBioPrimeKey from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 select @ProfileId=profileId from tblBioMetricProfileOxfordVerification with(nolock) where  userid = @userid ;
	 select @RemainEnrollments=RemainEnrollments from tblBioMetricProfileOxfordVerification with(nolock) where  userid = @userid ;
	 end

END

