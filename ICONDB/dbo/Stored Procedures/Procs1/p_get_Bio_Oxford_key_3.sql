-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_key_3]

@facilityID int,
@DivID int,
@UserId varchar(16),
@MicrosoftKey      varchar(100) OUTPUT,
@SharedPort      int OUTPUT,
@SharedPortException      int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	set @MicrosoftKey = ''
	set @SharedPort = 0
	set @SharedPortException = 0
	
	 begin
	 select @MicrosoftKey=VoiceBioPrimeKey from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 select @SharedPort=SharedPort from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 select @SharedPortException=SharedPort from tblBioMetricProfileOxfordVerification with(nolock) where  UserId = @UserId ;
	 end
	
	

END

