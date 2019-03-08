-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_Previous_Language_V2]
@FacilityID int,
@InmateID		varchar(12),
@BioStatus	tinyint OUTPUT,
@RemainEnrollments	tinyint OUTPUT,
@LanguageSelected varchar(6) output

AS
BEGIN
	SET NOCOUNT ON;
	declare @UserID varchar(50)
		SET @LanguageSelected = 0;
		SET @RemainEnrollments = 9;
		SET @UserID = cast(@facilityID as Varchar(4)) + '-' + @InmateID;
		
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1)  >0
		select @BioStatus = (select top 1 isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1 );
		select @LanguageSelected = (select  Abbrev from tblLanguages with(nolock) where AcpSelectOpt = (Select top 1 primaryLanguage from tblInmate 
		where  facilityID = @FacilityID and InmateID=@InmateID and status = 1 order by InputDate));
		--select @LanguageSelected
		Select @RemainEnrollments = Case when (Select top 1 isnull(primaryLanguage,0) from tblInmate with(nolock) 
		where FacilityID =@FacilityID and InmateID=@InmateID and status = 1 order by InputDate) < 2 
		then (select isnull(RemainEnrollments,9) from tblBioMetricProfileOxfordVerification with(nolock) where UserID =@UserID) 
		else (select  isnull(RemainEnrollments,9) from tblBioMetricProfileVoiceITVerification with(nolock) where UserID =@userID)  end;
	If @RemainEnrollments is Null
		set @RemainEnrollments = 9;
		--Select @RemainEnrollments
	    	
END

