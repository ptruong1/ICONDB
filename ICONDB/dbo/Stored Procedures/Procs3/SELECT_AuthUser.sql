
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_AuthUser] 
(
	@authID int
	
)
AS
	SET NOCOUNT ON;

	select [AuthID]
      ,isnull(FacilityConfig,0) as FacilityConfig
      ,isnull(UserControl,0) as UserControl
      ,isnull(PhoneConfig,0) as PhoneConfig
      ,isnull(CallControl,0) as CallControl
      ,isnull(DebitCard,0) as DebitCard
      ,isnull(InmateProfile,0) as InmateProfile
      ,isnull(Report,0) as Report
      ,isnull(CallMonitor,0) as CallMonitor
      ,isnull(Messaging,0) as Messaging
      ,isnull(VideoVisit,0) as VideoVisit
      ,isnull(ServiceRequest,0) as ServiceRequest
      
  FROM [leg_Icon].[dbo].[tblAuthUsers] where authID = @authID
