-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_Previous_Language]
@FacilityID int,
@InmateID		varchar(12),
@LanguageSelected	Varchar(6) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
		SET @LanguageSelected = 0;
		
	 if (select COUNT(*) from tblInmate with(nolock) where FacilityID =@FacilityID and InmateID=@InmateID and status = 1)  >0
		set @LanguageSelected = (select  Abbrev from tblLanguages with(nolock) where AcpSelectOpt = (Select top 1 isnull(primaryLanguage,0) from tblInmate 
		where  facilityID = @FacilityID and InmateID=@InmateID and status = 1))
		select @LanguageSelected ;
    	
END

