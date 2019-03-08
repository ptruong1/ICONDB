-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE p_insert_kiosk_activity 
	@DeviceName varchar(20),
	@ActType tinyint,
	@FacilityID int,
	@InmateID varchar(12)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @nextID bigint;
	EXEC    p_create_nextID 'tblKioskActivity', @nextID   OUTPUT;


	Insert tblKioskActivity (ActID, DeviceName,ActType,ActTime,FacilityID, InmateID)
		   values(@nextID, @DeviceName, @ActType , getdate(), @FacilityID , @InmateID );

	
	Return 0;

   
END
