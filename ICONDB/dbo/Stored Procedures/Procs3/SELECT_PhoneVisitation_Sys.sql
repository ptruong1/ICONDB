
CREATE PROCEDURE [dbo].[SELECT_PhoneVisitation_Sys]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        ServerIP
FROM            tblVisitPhoneServer  with(nolock)
WHERE       (FacilityID = @FacilityID)

