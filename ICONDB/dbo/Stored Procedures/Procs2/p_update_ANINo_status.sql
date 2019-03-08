-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_ANINo_status] 
	@FacilityID int,
	@ANINo varchar(10),
	@status tinyint,
	@UserName varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    update leg_Icon.dbo.tblANIs 
		set [ANINoStatus] = @status 
			,[UserName] = @UserName
			,[modifyDate] = GETDATE()
    where
		facilityID = @FacilityID and 
		ANINO = @ANINo 
END

