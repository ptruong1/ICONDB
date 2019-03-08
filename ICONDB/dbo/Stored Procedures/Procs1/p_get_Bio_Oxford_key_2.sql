-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_key_2]

@facilityID int,
@DivID int,
@MicrosoftKey      varchar(100) OUTPUT,
@SharedPort      int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	set @MicrosoftKey = ''
	set @SharedPort = 0
	
	 begin
	 select @MicrosoftKey=VoiceBioPrimeKey from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 select @SharedPort=SharedPort from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 end
	
	

END

