﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_key_ProfileId_V1]

@facilityID int,
@DivID int,
@userid varchar(16),
@MicrosoftKey      varchar(100) OUTPUT,
@ProfileId      varchar(100) OUTPUT,
@RemainEnrollments int output,
@BioInmateID varchar(12) output,
@LanguageSelected varchar(6) output
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint,  @RemainCount int, @PIN varchar(12)
	Set @PIN = LTRIM(RIGHT(@UserID,LEN(@UserID) - CHARINDEX('-',@UserID) ))
	Set @LanguageSelected = 'Eng'
	set @MicrosoftKey = ''
	set @ProfileId = ''
	set @RemainEnrollments = 9
	set @BioInmateID = (Select InmateID from tblInmate where facilityID = @FacilityID and PIN = @PIN and Status = 1)
	
	 begin
	 select @MicrosoftKey=VoiceBioPrimeKey from tblFacilityMicrosoftAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
	 select @ProfileId=profileId from tblBioMetricProfileOxfordVerification with(nolock) where  userid = @userid ;
	 select @RemainEnrollments=RemainEnrollments from tblBioMetricProfileOxfordVerification with(nolock) where  userid = @userid ;
	 select @BioInmateID=BioInmateID from tblBioMetricProfileOxfordVerification with(nolock) where  userid = @userid ;
	 select @LanguageSelected=LanguageSelected from tblBioMetricProfileOxfordVerification with(nolock) where  userid = @userid ;
	 end
	 
END

