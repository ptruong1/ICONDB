-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_key_1]

@facilityID int,
@DivID int,
@MicrosoftKey      varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	set @MicrosoftKey = ''
	
	 begin
		select @MicrosoftKey=VoiceBioPrimeKey from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 end
	
	

END

