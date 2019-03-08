
CREATE PROCEDURE [dbo].[p_create_AuthFacilityTab]
(
	@AuthID bigint,
	@Config bit,
	@Schedule bit,
	@Layout bit
)	
AS
SET NOCOUNT OFF;
INSERT INTO [tblAuthFacilityTab] ([AuthID],[Config],[Schedule],[Layout]) VALUES (@AuthID, @Config, @Schedule, @Layout);
	
