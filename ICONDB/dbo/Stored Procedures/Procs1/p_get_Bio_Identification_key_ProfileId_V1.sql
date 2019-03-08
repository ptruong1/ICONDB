-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Identification_key_ProfileId_V1]
@facilityID int,
@DivID int,
@userid varchar(16)

AS

	SET NOCOUNT ON;
	Declare @InmateID varchar(12)
	Set @InmateID = LTRIM(RIGHT(@UserID,LEN(@UserID) - CHARINDEX('-',@UserID) ))
	
	 begin
	 select isnull(M.IdentificationPrimeKey, '') as IdentificationPrimeKey
		,isnull(I.UserID, '') as userID
      ,isnull(I.ProfileID, '') as ProfileId
      ,isnull(I.RemainEnrollments,9) as RemainEnrollments
      ,isnull(I.LanguageSelected, 'Eng') as LanguageSelected
      ,isnull((Select top 1 InmateID from tblInmate where facilityID = @FacilityID and InmateID = @InmateID and Status = 1 order by InputDate), '') as BioInmateId
      ,isnull(I.StationId, '') as StationId
      ,isnull(I.LocId, 0) as LocId
      ,isnull(I.DivId, 0) as DivId
      ,isnull(I.RecordId, '') as RecordId
	  ,isnull(I.EnrolledFilePath, '') as EnrolledFilePath
	  from tblFacilityMicrosoftIdentificationAccount M
	  left join tblBioMetricProfileOxfordIdentification I on userid = @UserId
	  where  M.facilityID = @facilityId and M.DivID = 0  
	 end
	 


--@facilityID int,
--@DivID int,
--@userid varchar(16),
--@MicrosoftKey      varchar(100) OUTPUT,
--@ProfileId      varchar(100) OUTPUT,
--@RemainEnrollments int output,
--@BioInmateID varchar(12) output,
--@LanguageSelected varchar(6) output
--AS
--BEGIN
--	SET NOCOUNT ON;
--	Declare @bioRegister tinyint,  @RemainCount int, @PIN varchar(12)
--	Set @PIN = LTRIM(RIGHT(@UserID,LEN(@UserID) - CHARINDEX('-',@UserID) ))
--	Set @LanguageSelected = 'Eng'
--	set @MicrosoftKey = ''
--	set @ProfileId = ''
--	set @RemainEnrollments = 9
--	set @BioInmateID = (Select InmateID from tblInmate where facilityID = @FacilityID and PIN = @PIN and Status = 1)
	
--	 begin
--	 select @MicrosoftKey=IdentificationPrimeKey from tblFacilityMicrosoftIdentificationAccount with(nolock) where  facilityID = @facilityID and DivID = @DivID ;
--	 select @ProfileId=profileId from tblBioMetricTransOxfordIdentification with(nolock) where  userid = @userid ;
--	 select @RemainEnrollments=RemainEnrollments from tblBioMetricTransOxfordIdentification with(nolock) where  userid = @userid ;
--	 select @BioInmateID=isnull(BioInmateID,'') from tblBioMetricTransOxfordIdentification with(nolock) where  userid = @userid ;
--	 select @LanguageSelected=isnull(LanguageSelected,'Eng') from tblBioMetricTransOxfordIdentification with(nolock) where  userid = @userid ;
--	 end
	 
--END

