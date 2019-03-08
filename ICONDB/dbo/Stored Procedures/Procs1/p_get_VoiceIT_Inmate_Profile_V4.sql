-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_VoiceIT_Inmate_Profile_V4]

@facilityID int,
@userid varchar(16),
@userEmail     varchar(50),
@contentLanguageOpt varchar(12)
AS

	SET NOCOUNT ON;
	declare @InmateID varchar(12)
	set @InmateID = LTRIM(RIGHT(@UserID,LEN(@UserID) - CHARINDEX('-',@UserID) ))
		
	IF (SELECT Count(*)  FROM [leg_Icon].[dbo].tblBioMetricProfileVoiceITVerification WHERE UserEmail = @userEmail  )  >0
	begin
	Select [UserEmail]
      ,[password]
      ,[UserID]
      ,[FirstName]
      ,[LastName]
      ,[Phone1]
      ,[Phone2]
      ,[Phone3]
      ,[RemainEnrollments]
      ,isnull(LanguageContent, 'No-STT') as ContentLanguage
	  ,isnull(ConfidentLevel,50) as Confidence
	  FROM tblBioMetricProfileVoiceITVerification
	  left join tblLanguages on tblLanguages.Abbrev = @contentLanguageOpt
	  
	  WHERE userEmail = @UserEmail
	  
	  end
	Else
	begin
		Select (@UserID + '@No.com') as UserEmail
		  ,('Legacy' + @InmateID) as Password
		  ,@UserID as userID
		  ,[FirstName]
		  ,[LastName]
		  ,'999-999-9999' as [Phone1]
		  ,'' [Phone2]
		  ,'' [Phone3]
		  ,9 as [RemainEnrollments]
		  ,isnull(LanguageContent, 'No-STT') as ContentLanguage
		  ,isnull(ConfidentLevel,50) as Confidence
		FROM tblInmate
		left join tblLanguages on tblLanguages.Abbrev = @contentLanguageOpt
		WHERE tblInmate.FacilityID = @FacilityId  and
		InmateID = @InmateID 
		and Status = 1
	End

