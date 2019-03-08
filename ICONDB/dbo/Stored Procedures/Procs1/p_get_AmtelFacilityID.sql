-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_get_AmtelFacilityID] 
@FacilityID int,
@AmtelFacilityID varchar(5) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET  @AmtelFacilityID='0';
    select @AmtelFacilityID = isnull(FTPfolderName,'0') from tblFacilityOption with(nolock) where FacilityID = @FacilityID;
END

