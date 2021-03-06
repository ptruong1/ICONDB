﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_Oxfordbiometric_Inmate_V5]
@FacilityID int,
@InmateID		varchar(12),
@UserID		varchar(16),
@BioStatus	tinyint OUTPUT,
@RemainEnrollments	tinyint OUTPUT,
@LanguageSelected varchar(6) output
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint ;
	SET @BioStatus = 3;
	SET @RemainEnrollments = 9;
	SET @LanguageSelected = 100;
		
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1)  >0
		select @BioStatus = (select top 1 isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1 );
		select @LanguageSelected = isnull((select  Abbrev from tblLanguages with(nolock) where AcpSelectOpt = (Select top 1 isnull(primaryLanguage,1) from tblInmate 
		where  facilityID = @FacilityID and InmateID=@InmateID and status = 1 order by InputDate)),'Unk')
		--select isnull(@LanguageSelected,100) ;
		select @RemainEnrollments = isnull(RemainEnrollments,0) from tblBioMetricProfileOxfordVerification with(nolock) where UserID =@UserID ;
    	
END

