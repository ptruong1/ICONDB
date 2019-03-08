-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_update_inmate_language]
@FacilityID int,
@InmateID varchar(12),
@SelectedLanguage tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Update tblinmate set PrimaryLanguage= @SelectedLanguage where FacilityId = @FacilityID and InmateID =@InmateID;

	select @@ERROR as Success;
   
END

