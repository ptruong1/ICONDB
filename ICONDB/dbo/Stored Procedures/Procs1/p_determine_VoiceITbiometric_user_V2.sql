-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_VoiceITbiometric_user_V2]
@FacilityID int,
@InmateID		varchar(12),
@UserID		varchar(16),
@BioStatus	tinyint OUTPUT,
@RemainEnrollments	tinyint OUTPUT,
@LanguageSelected	int OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	SET @BioStatus = 3;
	SET @RemainEnrollments = 9;
	SET @LanguageSelected = 0;
		
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1)  >0
		select @BioStatus = isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1 ;
		select @RemainEnrollments = isnull(RemainEnrollments,0) from tblBioMetricProfileVoiceITVerification with(nolock) where UserEmail = (@UserID + '@no.com') ;
		select @LanguageSelected = isnull(LanguageSelected,0) from tblBioMetricProfileVoiceITVerification with(nolock) where UserEmail = (@UserID + '@no.com') ;
    	
END

