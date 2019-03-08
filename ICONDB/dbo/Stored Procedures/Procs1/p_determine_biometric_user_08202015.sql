-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_determine_biometric_user_08202015]
@FacilityID int,
@InmateID	varchar(12),
@PIN		varchar(12),
@ACP		varchar(16),
@UserStatus	tinyint OUTPUT,
@DriveMap	varchar(2) OUTPUT,
@AlertCellPhones	varchar(30) OUTPUT,
@AlertEmails	varchar(50) OUTPUT,
@AlertMessage	varchar(200) OUTPUT,
@ScoreRq int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @bioRegister tinyint;
	SET @bioRegister =0;
	SET @UserStatus =0;
	SET @DriveMap ='';
	SET @AlertEmails ='';
	SET @AlertCellPhones ='';
	SET @AlertMessage ='';
	SET @ScoreRq = 0;
	---For testing
	--if(@facilityID >1)
		--return 0;
	
	if((select COUNT(*) from tblFacilityOption with(nolock) where FacilityID = @FacilityID and BioMetric=1)  >0 and @FacilityID in (1,556,670,686))
	 begin
		select @AlertEmails=AlertEmails from tblAlertPINs with(nolock) where FacilityID = @FacilityID and PIN=@PIN ;
		select @AlertCellPhones=AlertCellPhones from tblAlertPINs with(nolock) where FacilityID = @FacilityID  and PIN=@PIN;
		select @AlertMessage=AlertMessage from tblAlertPINs with(nolock) where  FacilityID = @FacilityID  and PIN=@PIN;
		select @bioRegister = isnull(BioRegister,0) from tblInmate with(nolock) where FacilityID =@FacilityID and inmateID =@InmateID and PIN=@PIN ;
		select @ScoreRq = score from tblfacilitybiometric with(nolock) where FacilityID = @FacilityID;
		if(@bioRegister =0)
			SET  @UserStatus =1;
		else
			SET  @UserStatus =2;
	 end
	select @DriveMap=DriveMap from tblACPs with(nolock) where IpAddress =@ACP ; 
	

END

