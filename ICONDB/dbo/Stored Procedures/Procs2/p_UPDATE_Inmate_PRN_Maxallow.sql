-- =============================================
-- Author:		<Author,,Name>
-- Modified Date 2/14/2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_UPDATE_Inmate_PRN_Maxallow]
(
	@PIN Varchar(12),
	@InmateID Varchar(12),
	@FacilityId int,
	@Type varchar(3),
	@OriginalLimit int,
	@MaxAllow int
	
	
)
AS
BEGIN
	SET NOCOUNT OFF;
	UPDATE  [tblInmate] SET [NotAllowLimit] = @MaxAllow
			WHERE (InmateID = @InmateId AND [FacilityId] = @FacilityId and PIN = @PIN) ;
END

