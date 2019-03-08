-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_Bio_Oxford_Identification]

@facilityID int,
@PIN	varchar(12),
@UserID varchar(16),
@AlertCellPhones	varchar(30) OUTPUT,
@AlertEmails	varchar(50) OUTPUT,
@ProfileID      varchar(100) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	SET @bioRegister =0;
	SET @AlertEmails ='';
	SET @AlertCellPhones ='';
	set @ProfileID = ''
	
	--if((select COUNT(*) from tblFacilityOption with(nolock) where FacilityID = @FacilityID and BioMetric=1)  >0 and @FacilityID in (1,556,670,686))
	 begin
		select @AlertEmails=AlertEmails from tblAlertPINs with(nolock) where FacilityID = @FacilityID and PIN=@PIN ;
		select @AlertCellPhones=AlertCellPhones from tblAlertPINs with(nolock) where FacilityID = @FacilityID  and PIN=@PIN;
		select @ProfileID=ProfileId from tblBioMetricTransOxfordIdentification with(nolock) where  userID = @UserID;
	 end
	
	

END

