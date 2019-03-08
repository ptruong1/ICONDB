
CREATE PROCEDURE [dbo].[p_get_Facility_by_DID]
@DID		varchar(10)

 AS
BEGIN
	Declare @FacilityID int,  @rateplanID varchar(7),  @ChargePerMessage numeric(6,4),@VoiceMessageOpt tinyint,  @InfoSysOpt tinyint, @Languages varchar(20), @MainMenuOption varchar(50), @status tinyint, @duration smallint;

	SET @ChargePerMessage  =1;
	SET @VoiceMessageOpt =0;
	SET @InfoSysOpt =0;
	SET @FacilityID =0;
	SET @Languages='Eng#1_Spn#2';
	SET @MainMenuOption = 'PPS#0';
	SET @status =0;
	SET  @duration = 60;

	SELECT  @FacilityID=FacilityID,@rateplanID= rateplanID, @status = [status]   from tblFacility with(nolock) where  DID =@DID or tollFreeNo = @DID;
	if(@status =1) 
	begin
		Select @VoiceMessageOpt =isnull(VoiceMessageOpt,0),@InfoSysOpt=  isnull(InfoSysOpt,0)   from tblFacilityOption where FacilityID = @FacilityID ;
		if (@InfoSysOpt=1 and @VoiceMessageOpt=1)
			SET @MainMenuOption = 'AIS#1_VMS#2_' + @MainMenuOption;
		ELSE if(@InfoSysOpt=1)
			SET @MainMenuOption = 'AIS#1_' + @MainMenuOption;
		ElSE IF (@VoiceMessageOpt=1)
			SET @MainMenuOption = 'VMS#1_' + @MainMenuOption;
		Else
			SET @MainMenuOption = 'PPS#0';		 
		Select  @ChargePerMessage = isnull(Charge,1 )   from   tblMessageRate with(nolock)  where   FacilityID =@rateplanID;
		Select @duration= isnull(voicelength,30) from tblFacilityMessageConfig with(nolock) where FacilityID= @FacilityID;
	 end
	else
		SET @MainMenuOption = 'DBT#1';
	Select  @FacilityID as FacilityID,   @ChargePerMessage as  ChargePerMessage, @Languages as Languages, @MainMenuOption as MainMenuOption, @duration as MessageDuration ;
END
