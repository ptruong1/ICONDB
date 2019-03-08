

CREATE PROCEDURE [dbo].[p_get_speedDialNo]
(
	@speedDialID varchar(3),
	@FacilityID int,
	@PhoneNo varchar(10)
)
AS
Begin
	SET NOCOUNT ON;

	--Select @PhoneNo = PhoneNo from tblSpeedDial with(nolock) where [SpeedDialID]= @speedDialID AND FacilityID = @FacilityID
	If (@PhoneNo is null or @PhoneNo='')
		Return -1

End
