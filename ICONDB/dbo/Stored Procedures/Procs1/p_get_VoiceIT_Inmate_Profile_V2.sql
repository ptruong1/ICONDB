-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_VoiceIT_Inmate_Profile_V2]

@facilityID int,
@userid varchar(16),
@userEmail     varchar(50),
@contentLanguage varchar(12)
AS

	SET NOCOUNT ON;
	declare @Userpin varchar(12)
	set @UserPin = LTRIM(RIGHT(@UserID,LEN(@UserID) - CHARINDEX('-',@UserID) ))
		
	IF (SELECT Count( userEmail)  FROM tblBioMetricProfileVoiceITVerification WHERE userEmail = @UserEmail  )  >0
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
      ,[ContentLanguage]
	  ,isnull(ConfidentLevel,50) as Confidence
	  FROM tblBioMetricProfileVoiceITVerification
	  left join tblLanguages on tblLanguages.languageContent = @contentLanguage
	  
	  WHERE userEmail = @UserEmail
	  
	  end
	Else
	Select (@UserID + '@No.com') as UserEmail
      ,('Legacy' + @UserPin) as Password
      ,@UserID as userID
      ,[FirstName]
      ,[LastName]
      ,'999-999-9999' as [Phone1]
      ,'' [Phone2]
      ,'' [Phone3]
      ,9 as [RemainEnrollments]
      ,'' [ContentLanguage]
	  ,isnull(ConfidentLevel,50) as Confidence
	FROM tblInmate
	left join tblLanguages on tblLanguages.languageContent = @contentLanguage
	WHERE tblInmate.FacilityID = @FacilityId  and
	PIN = @UserPin 
	and Status = 1


